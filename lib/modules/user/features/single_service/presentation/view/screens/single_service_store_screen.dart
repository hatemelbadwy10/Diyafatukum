import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/app_dialog.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../common/features/auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../../../common/features/bag/data/model/bag_model.dart';
import '../../../../../../common/features/bag/data/repository/bag_repository.dart';
import '../../../../../../common/features/shared/presentation/view/widgets/login_dialog.dart';
import '../../../data/model/single_service_store_model.dart';
import '../../controller/single_service_store_cubit/single_service_store_cubit.dart';
import '../widgets/single_service_store_bottom_bar.dart';
import '../widgets/single_service_store_categories.dart';
import '../widgets/single_service_store_header.dart';
import '../widgets/single_service_store_item_card.dart';

class SingleServiceStoreScreen extends StatelessWidget {
  const SingleServiceStoreScreen({super.key, required this.arguments});

  final SingleServiceStoreScreenArguments arguments;

  Future<void> _addItemsToCart({
    required BuildContext context,
    required SingleServiceStoreCubit cubit,
    required List<BagItemModel> selectedItems,
    required int? currentStoreId,
  }) async {
    final result = await sl<BagRepository>().addItems(selectedItems);
    if (!context.mounted) return;

    result.fold((failure) => Toaster.showToast(failure.message), (response) {
      context.maybeRead<AuthCubit>()?.updateUserCartStoreId(currentStoreId);
      cubit.clearSelection();
      Toaster.showToast(
        response.message?.trim().isNotEmpty == true
            ? response.message!
            : LocaleKeys.home_user_store_booking_success.tr(),
        isError: false,
      );
    });
  }

  Future<void> _replaceCartAndAddItems({
    required BuildContext context,
    required SingleServiceStoreCubit cubit,
    required List<BagItemModel> selectedItems,
    required int? currentStoreId,
  }) async {
    final clearResult = await sl<BagRepository>().clearCart();
    if (!context.mounted) return;

    await clearResult.fold(
      (failure) async => Toaster.showToast(failure.message),
      (_) async {
        context.maybeRead<AuthCubit>()?.updateUserCartStoreId(null);
        await _addItemsToCart(
          context: context,
          cubit: cubit,
          selectedItems: selectedItems,
          currentStoreId: currentStoreId,
        );
      },
    );
  }

  Future<void> _handleAddToCart({
    required BuildContext context,
    required SingleServiceStoreCubit cubit,
    required List<BagItemModel> selectedItems,
  }) async {
    final authCubit = context.maybeRead<AuthCubit>();
    if (!(authCubit?.state.status.isAuthorized ?? false)) {
      LoginDialog().show(context);
      return;
    }
    final currentStoreId = int.tryParse(arguments.store.id);
    final cartStoreId = authCubit?.state.user.cartStoreId;

    if (currentStoreId != null &&
        cartStoreId != null &&
        cartStoreId != currentStoreId) {
      final bagResult = await sl<BagRepository>().getBag();
      if (!context.mounted) return;

      final hasItems = bagResult.fold(
        (_) => true,
        (response) => response.data?.items.isNotEmpty ?? false,
      );

      if (hasItems) {
        AppDialog(
          title: LocaleKeys.home_user_store_cart_conflict_title.tr(),
          subtitle: LocaleKeys.home_user_store_cart_conflict_message.tr(),
          confirmLabel: LocaleKeys.actions_clear.tr(),
          cancelLabel: LocaleKeys.actions_cancel.tr(),
          confirmDestructive: true,
          onConfirm: () async {
            await _replaceCartAndAddItems(
              context: context,
              cubit: cubit,
              selectedItems: selectedItems,
              currentStoreId: currentStoreId,
            );
          },
          icon: Icon(
            Icons.storefront_rounded,
            color: context.onPrimary,
            size: 28,
          ),
        ).show(context);
        return;
      }
    }

    await _addItemsToCart(
      context: context,
      cubit: cubit,
      selectedItems: selectedItems,
      currentStoreId: currentStoreId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SingleServiceStoreCubit>()
            ..initialize(arguments.service, arguments.store),
      child: Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar.build(
          removeBack: false,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const SizedBox.shrink(),
        ),
        bottomNavigationBar:
            BlocBuilder<SingleServiceStoreCubit, SingleServiceStoreState>(
              builder: (context, state) {
                final cubit = context.read<SingleServiceStoreCubit>();
                final selectedItems = state.items
                    .where((item) => state.quantityFor(item.id) > 0)
                    .map(
                      (item) => BagItemModel(
                        id: item.id,
                        productId: item.id,
                        name: item.name,
                        price: item.price,
                        imagePath: item.imagePath,
                        quantity: state.quantityFor(item.id),
                      ),
                    )
                    .toList();

                return SingleServiceStoreBottomBar(
                  totalPrice: state.totalPrice,
                  selectedItemsCount: state.selectedItemsCount,
                  onTap: () => _handleAddToCart(
                    context: context,
                    cubit: cubit,
                    selectedItems: selectedItems,
                  ),
                ).visible(state.hasSelection);
              },
            ),
        body: BlocBuilder<SingleServiceStoreCubit, SingleServiceStoreState>(
          builder: (context, state) {
            final cubit = context.read<SingleServiceStoreCubit>();

            return state.status.build(
              onLoading: () => const CustomLoading(),
              onFailed: () => CustomFallbackView(
                title: LocaleKeys.error_ops.tr(),
                subtitle: state.status.message,
                buttonLabel: LocaleKeys.actions_retry.tr(),
                onButtonPressed: () =>
                    cubit.initialize(arguments.service, arguments.store),
              ),
              onSuccess: (_) => CustomScrollView(
                slivers: [
                  if (state.storeDetails != null)
                    SingleServiceStoreHeader(
                      store: state.storeDetails!,
                    ).toSliver(),
                  20.gap.toSliver(),
                  SingleServiceStoreCategories(
                    categories: state.categories,
                    selectedCategoryId: state.selectedCategoryId,
                    onCategorySelected: cubit.selectCategory,
                  ).toSliver(),
                  20.gap.toSliver(),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.screenPadding,
                    ),
                    sliver: SliverList.separated(
                      itemCount: state.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = state.filteredItems[index];
                        return SingleServiceStoreItemCard(
                          item: item,
                          quantity: state.quantityFor(item.id),
                          onSelect: () => cubit.selectItem(item),
                          onIncrement: () => cubit.incrementItem(item),
                          onDecrement: () => cubit.decrementItem(item),
                        );
                      },
                      separatorBuilder: (_, _) => 16.gap,
                    ),
                  ),
                  28.gap.toSliver(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
