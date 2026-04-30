import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_arrow_back.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../common/features/bag/data/model/bag_model.dart';
import '../../../data/model/single_service_store_model.dart';
import '../../controller/single_service_store_cubit/single_service_store_cubit.dart';
import '../widgets/single_service_store_bottom_bar.dart';
import '../widgets/single_service_store_categories.dart';
import '../widgets/single_service_store_checkout_bottom_sheet.dart';
import '../widgets/single_service_store_header.dart';
import '../widgets/single_service_store_item_card.dart';

class SingleServiceStoreScreen extends StatelessWidget {
  const SingleServiceStoreScreen({super.key, required this.arguments});

  final SingleServiceStoreScreenArguments arguments;

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
                return SingleServiceStoreBottomBar(
                  totalPrice: state.totalPrice,
                  selectedItemsCount: state.selectedItemsCount,
                  onTap: () => context.showBottomSheet(
                    SingleServiceStoreCheckoutBottomSheet(
                      authCubit: context.maybeRead(),
                      selectedItems: state.items
                          .where((item) => state.quantityFor(item.id) > 0)
                          .map(
                            (item) => BagItemModel(
                              id: item.id,
                              name: item.name,
                              price: item.price,
                              imagePath: item.imagePath,
                              quantity: state.quantityFor(item.id),
                            ),
                          )
                          .toList(),
                    ),
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
