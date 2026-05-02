import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/app_dialog.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../shared/data/model/navigation_bar_items.dart';
import '../../controller/bag_cubit/bag_cubit.dart';
import '../widgets/bag_item_card.dart';
import '../widgets/bag_checkout_bottom_sheet.dart';
import '../widgets/bag_summary_section.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  @override
  void initState() {
    super.initState();
    bottomNavNotifier.addListener(_handleNavigationChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BagCubit>().loadBag();
      }
    });
  }

  @override
  void dispose() {
    bottomNavNotifier.removeListener(_handleNavigationChange);
    super.dispose();
  }

  void _handleNavigationChange() {
    if (!mounted || bottomNavNotifier.value != NavigationBarItems.stores) {
      return;
    }
    context.read<BagCubit>().loadBag();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar.build(
        titleText: LocaleKeys.bag_title.tr(),
        titleStyle: context.displaySmall.bold.s18,
        backgroundColor: context.scaffoldBackgroundColor,
      ),
      body: BlocListener<BagCubit, BagState>(
        listener: (context, state) {
          // Show snackbar only for update errors, not initial load errors
          if (state.status.isFailed && state.bag.items.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.status.message),
                backgroundColor: context.errorColor,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: BlocBuilder<BagCubit, BagState>(
          builder: (context, state) {
            final cubit = context.read<BagCubit>();

            return state.status.build(
              onLoading: () => const CustomLoading(),
              onFailed: () => CustomFallbackView(
                title: LocaleKeys.error_ops.tr(),
                subtitle: state.status.message,
                buttonLabel: LocaleKeys.actions_retry.tr(),
                onButtonPressed: cubit.loadBag,
              ),
              onSuccess: (_) => Column(
                children: [
                  VerticalListView(
                    itemCount: state.isEmpty ? 1 : state.bag.items.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.screenPadding,
                      vertical: 20,
                    ),
                    separator: 16.gap,
                    itemBuilder: (context, index) {
                      if (state.isEmpty) {
                        return SizedBox(
                          height: context.height * 0.45,
                          child: CustomFallbackView(
                            icon: Assets.icons.solarCartCheckBroken.svg(
                              width: 72,
                              height: 72,
                              colorFilter: context.primaryColor.colorFilter,
                            ),
                            title: LocaleKeys.bag_empty_title.tr(),
                            subtitle: LocaleKeys.bag_empty_subtitle.tr(),
                            buttonLabel: LocaleKeys.bag_empty_action.tr(),
                            onButtonPressed: () {
                              bottomNavNotifier.value = NavigationBarItems.home;
                              AppRoutes.home.go();
                            },
                          ),
                        );
                      }

                      final item = state.bag.items[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          final shouldDelete = await AppDialog(
                            title: LocaleKeys.bag_actions_remove_item_title.tr(),
                            subtitle: LocaleKeys.bag_actions_remove_item_message
                                .tr(),
                            confirmLabel: LocaleKeys.actions_delete.tr(),
                            cancelLabel: LocaleKeys.actions_cancel.tr(),
                            confirmDestructive: true,
                            confirmResult: true,
                            cancelResult: false,
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: context.onPrimary,
                              size: 28,
                            ),
                          ).show<bool>(context);
                          return shouldDelete == true;
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.screenPadding + 24,
                          ),
                          decoration: BoxDecoration(
                            color: context.errorColor,
                            borderRadius: 24.borderRadius,
                          ),
                          child: Assets.icons.trash.svg(
                            width: 34,
                            height: 34,
                            colorFilter: Colors.white.colorFilter,
                          ),
                        ),
                        onDismissed: (_) => cubit.removeItem(item.id),
                        child: BagItemCard(
                          item: item,
                          onIncrement: () => cubit.incrementItemQuantity(item.id),
                          onDecrement: () => cubit.decrementItemQuantity(item.id),
                        ),
                      );
                    },
                  ).expand(),
                  if (!state.isEmpty)
                    BagSummarySection(
                      bag: state.bag,
                      onCheckout: () => context.showBottomSheet(
                        BagCheckoutBottomSheet(
                          authCubit: context.maybeRead<AuthCubit>(),
                          bagCubit: cubit,
                        ),
                      ),
                    ).bottomSafeArea(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
