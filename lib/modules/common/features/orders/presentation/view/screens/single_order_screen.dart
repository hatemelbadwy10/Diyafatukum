import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/utils/overlay_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_button.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../controller/orders_cubit/orders_cubit.dart';
import '../../../data/model/order_model.dart';
import '../widgets/order_cancel_bottom_sheet.dart';
import '../widgets/order_timeline_status_style.dart';
import '../widgets/provider_order_status_card.dart';
import '../widgets/provider_order_reject_bottom_sheet.dart';
import '../widgets/single_order_info_tile.dart';
import '../widgets/single_order_section_card.dart';

class SingleOrderScreen extends StatelessWidget {
  const SingleOrderScreen({
    super.key,
    required this.order,
    this.isProviderView = false,
    this.ordersCubit,
  });

  final OrderModel order;
  final bool isProviderView;
  final OrdersCubit? ordersCubit;

  @override
  Widget build(BuildContext context) {
    final child = _SingleOrderView(order: order, isProviderView: isProviderView);
    if (ordersCubit != null) {
      return BlocProvider.value(value: ordersCubit!, child: child);
    }
    return BlocProvider(create: (_) => sl<OrdersCubit>(), child: child);
  }
}

class _SingleOrderView extends StatefulWidget {
  const _SingleOrderView({required this.order, required this.isProviderView});

  final OrderModel order;
  final bool isProviderView;

  @override
  State<_SingleOrderView> createState() => _SingleOrderViewState();
}

class _SingleOrderViewState extends State<_SingleOrderView> {
  late OrderModel _currentOrder;
  final ValueNotifier<bool> _isActionLoadingNotifier = ValueNotifier<bool>(
    false,
  );

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
  }

  @override
  void dispose() {
    _isActionLoadingNotifier.dispose();
    super.dispose();
  }

  bool get _isOrderCancelled =>
      _currentOrder.activeStatus == OrderTimelineStatus.cancelled ||
      _currentOrder.activeStatus == OrderTimelineStatus.rejected;

  Future<void> _showCancelBottomSheet() async {
    final ordersCubit = context.read<OrdersCubit>();
    final reason = await OverlayUtils.showBottomSheet<String>(
      context: context,
      child: BlocProvider.value(
        value: ordersCubit,
        child: OrderCancelBottomSheet(order: _currentOrder),
      ),
    );

    if (!mounted || reason == null || reason.trim().isEmpty) return;

    setState(() {
      _currentOrder = _currentOrder.copyWith(
        tabStatus: OrderTabStatus.cancelled,
        activeStatus: OrderTimelineStatus.cancelled,
        cancellationReason: reason,
        timeline: const [
          OrderTimelineStep(
            status: OrderTimelineStatus.cancelled,
            label: '',
            completed: true,
            current: true,
          ),
        ],
      );
    });
  }

  Future<void> _acceptProviderOrder() async {
    _isActionLoadingNotifier.value = true;
    final failure = await context.read<OrdersCubit>().acceptProviderOrder(
      _currentOrder.backendId,
    );
    if (!mounted) return;
    _isActionLoadingNotifier.value = false;

    if (failure != null) {
      Toaster.showToast(failure.message);
      return;
    }

    setState(() {
      _currentOrder = _currentOrder.markProviderAccepted();
    });
    Toaster.showToast(
      LocaleKeys.orders_details_actions_accept_success.tr(),
      isError: false,
    );
  }

  Future<void> _showRejectBottomSheet() async {
    final reason = await OverlayUtils.showBottomSheet<String>(
      context: context,
      child: BlocProvider.value(
        value: context.read<OrdersCubit>(),
        child: ProviderOrderRejectBottomSheet(order: _currentOrder),
      ),
    );

    if (!mounted || reason == null || reason.trim().isEmpty) return;

    setState(() {
      _currentOrder = _currentOrder.markProviderRejected(reason);
    });
  }

  Future<void> _advanceProviderOrderStatus() async {
    final nextStatus = _currentOrder.nextProviderStatus;
    if (nextStatus == null) return;

    _isActionLoadingNotifier.value = true;
    final failure = await context.read<OrdersCubit>().advanceProviderOrderStatus(
      id: _currentOrder.backendId,
      status: nextStatus,
    );
    if (!mounted) return;
    _isActionLoadingNotifier.value = false;

    if (failure != null) {
      Toaster.showToast(failure.message);
      return;
    }

    setState(() {
      _currentOrder = _currentOrder.markProviderAdvanced(nextStatus);
    });
    Toaster.showToast(
      LocaleKeys.orders_details_actions_advance_success.tr(),
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar.build(
        titleText: _currentOrder.id,
        titleStyle: context.titleMedium.bold,
        backgroundColor: context.scaffoldBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleOrderSectionCard(
            title: LocaleKeys.orders_single_store_title.tr(),
            children: [
              SingleOrderInfoTile(
                icon: Assets.icons.stashShopSolid.path.toSvg(
                  width: 64,
                  height: 64,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_single_store_name.tr(),
                value: _currentOrder.storeName,
              ),
              SingleOrderInfoTile(
                icon: Assets.icons.mdiPhoneOutline.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_single_store_phone.tr(),
                value: _currentOrder.storePhone,
              ),
            ],
          ),
          28.gap,
          SingleOrderSectionCard(
            title: LocaleKeys.orders_details_title.tr(),
            children: [
              SingleOrderInfoTile(
                icon: Assets.icons.iconParkOutlineTransactionOrder.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_details_items.tr(),
                value: _currentOrder.itemsSummary.join('\n'),
              ),
              SingleOrderInfoTile(
                icon: Assets.icons.fluentMdl2DateTime2.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.details_date_time_date.tr(),
                value: _currentOrder.dateLabel,
              ),
              SingleOrderInfoTile(
                icon: Assets.icons.ionLocationSharp.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_details_address.tr(),
                value: _currentOrder.address,
              ),
              SingleOrderInfoTile(
                icon: Assets.icons.editSquare.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_single_notes.tr(),
                value: _currentOrder.notes,
              ),
            ],
          ),
          28.gap,
          SingleOrderSectionCard(
            title: LocaleKeys.orders_single_payment_title.tr(),
            children: [
              SingleOrderInfoTile(
                icon: Assets.icons.materialSymbolsLightAttachMoney.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_single_payment_total_paid.tr(),
                value: '${_currentOrder.totalPaid.toStringAsFixed(0)} SAR',
              ),
            ],
          ),
          if (_currentOrder.canRequestCancellation &&
              !widget.isProviderView) ...[
            28.gap,
            CustomButton.destructive(
              label: LocaleKeys.orders_details_actions_cancel_title.tr(),
              onPressed: _showCancelBottomSheet,
            ),
          ],
          if (_isOrderCancelled) ...[
            28.gap,
            Text(
              LocaleKeys.orders_details_status_title.tr(),
              style: context.titleMedium.semiBold.s16.setColor(
                context.colorScheme.onSurface,
              ),
            ),
            20.gap,
            ProviderOrderStatusCard(
              step: OrderTimelineStep(
                status: _currentOrder.activeStatus,
                label: '',
                completed: true,
                current: true,
              ),
              cancellationReason: _currentOrder.cancellationReason,
            ),
          ] else if (widget.isProviderView) ...[
            28.gap,
            ValueListenableBuilder<bool>(
              valueListenable: _isActionLoadingNotifier,
              builder: (context, isLoading, _) => _ProviderOrderActionsSection(
                order: _currentOrder,
                isLoading: isLoading,
                onAccept: _acceptProviderOrder,
                onReject: _showRejectBottomSheet,
                onAdvance: _advanceProviderOrderStatus,
              ),
            ),
            28.gap,
            Text(
              LocaleKeys.orders_details_status_title.tr(),
              style: context.titleMedium.semiBold.s16.setColor(
                context.colorScheme.onSurface,
              ),
            ),
            20.gap,
            ..._currentOrder.timeline.map(
              (step) => ProviderOrderStatusCard(
                step: step,
                cancellationReason: _currentOrder.cancellationReason,
              ).paddingBottom(16),
            ),
          ],
        ],
      ).withListView(padding: AppSize.screenPadding.edgeInsetsWithBottomNavBar),
    );
  }
}

class _ProviderOrderActionsSection extends StatelessWidget {
  const _ProviderOrderActionsSection({
    required this.order,
    required this.isLoading,
    required this.onAccept,
    required this.onReject,
    required this.onAdvance,
  });

  final OrderModel order;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    if (order.canProviderAccept || order.canProviderReject) {
      return Row(
        children: [
          CustomButton.destructive(
            label: LocaleKeys.orders_details_actions_reject_title.tr(),
            onPressed: onReject,
            isLoading: isLoading,
          ).expand(),
          12.gap,
          CustomButton(
            label: LocaleKeys.orders_details_actions_accept_title.tr(),
            onPressed: onAccept,
            isLoading: isLoading,
          ).expand(),
        ],
      );
    }

    if (order.canProviderAdvanceStatus) {
      return CustomButton(
        label: LocaleKeys.orders_details_actions_advance_confirm.tr(
          args: [order.nextProviderStatus!.titleKey.tr()],
        ),
        onPressed: onAdvance,
        isLoading: isLoading,
      );
    }

    return const SizedBox.shrink();
  }
}
