import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_button.dart';
import '../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../controller/orders_cubit/orders_cubit.dart';
import '../../../data/model/order_model.dart';

class OrderCancelBottomSheet extends StatefulWidget {
  const OrderCancelBottomSheet({super.key, required this.order});

  final OrderModel order;

  @override
  State<OrderCancelBottomSheet> createState() => _OrderCancelBottomSheetState();
}

class _OrderCancelBottomSheetState extends State<OrderCancelBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController(
      text: LocaleKeys.orders_details_actions_cancel_reason_default.tr(),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listenWhen: (previous, current) =>
          previous.cancelStatus != current.cancelStatus,
      listener: (context, state) => state.cancelStatus.listen(
        onFailed: (failure) => Toaster.showToast(failure.message),
        onSuccess: (_) {
          Navigator.of(context).pop(_reasonController.text.trim());
          Toaster.showToast(state.cancelStatus.message, isError: false);
        },
      ),
      builder: (context, state) {
        return CustomBottomSheet(
          title: LocaleKeys.orders_details_actions_cancel_title.tr(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.orders_details_actions_cancel_message.tr(),
                  style: context.bodyMedium.s14.setColor(
                    context.colorScheme.onSurface,
                  ),
                ),
                16.gap,
                _PolicyInfoCard(order: widget.order),
                16.gap,
                CustomTextField(
                  controller: _reasonController,
                  title: LocaleKeys.orders_details_actions_cancel_reason_title
                      .tr(),
                  hint: LocaleKeys.orders_details_actions_cancel_reason_hint
                      .tr(),
                  inputType: InputType.text,
                  maxLines: 3,
                ),
                24.gap,
                CustomButton.destructive(
                  isLoading: state.cancelStatus.isLoading,
                  label: LocaleKeys.orders_details_actions_cancel_confirm.tr(),
                  onPressed: () {
                    if (_formKey.currentState?.validate() != true) return;

                    context.read<OrdersCubit>().cancelOrder(
                      id: widget.order.backendId,
                      reason: _reasonController.text.trim(),
                    );
                  },
                ),
              ],
            ).paddingHorizontal(AppSize.screenPadding),
          ),
        ).paddingBottom(context.keyboardPadding);
      },
    );
  }
}

class _PolicyInfoCard extends StatelessWidget {
  const _PolicyInfoCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final policyKey = switch (order.cancellationPolicy) {
      OrderCancellationPolicy.full =>
        LocaleKeys.orders_details_actions_cancel_policy_estimate_full,
      OrderCancellationPolicy.half =>
        LocaleKeys.orders_details_actions_cancel_policy_estimate_half,
      OrderCancellationPolicy.quarter =>
        LocaleKeys.orders_details_actions_cancel_policy_estimate_quarter,
      OrderCancellationPolicy.none =>
        LocaleKeys.orders_details_actions_cancel_policy_estimate_none,
      OrderCancellationPolicy.review =>
        LocaleKeys.orders_details_actions_cancel_policy_estimate_review,
    };

    return Container(
      padding: 16.edgeInsetsAll,
      decoration: BoxDecoration(
        color: context.greySwatch.shade50,
        borderRadius: 16.borderRadius,
        border: Border.all(color: context.greySwatch.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.orders_details_actions_cancel_policy_title.tr(),
            style: context.titleSmall.semiBold.setColor(
              context.colorScheme.onSurface,
            ),
          ),
          8.gap,
          Text(
            policyKey.tr(),
            style: context.bodySmall.s13.setColor(context.greySwatch.shade700),
          ),
          12.gap,
          Text(
            LocaleKeys.orders_details_actions_cancel_policy_full.tr(),
            style: context.bodySmall.s13.setColor(context.greySwatch.shade700),
          ),
          8.gap,
          Text(
            LocaleKeys.orders_details_actions_cancel_policy_half.tr(),
            style: context.bodySmall.s13.setColor(context.greySwatch.shade700),
          ),
          8.gap,
          Text(
            LocaleKeys.orders_details_actions_cancel_policy_quarter.tr(),
            style: context.bodySmall.s13.setColor(context.greySwatch.shade700),
          ),
          8.gap,
          Text(
            LocaleKeys.orders_details_actions_cancel_policy_none.tr(),
            style: context.bodySmall.s13.setColor(context.greySwatch.shade700),
          ),
          8.gap,
          Text(
            LocaleKeys.orders_details_actions_cancel_policy_execution.tr(),
            style: context.bodySmall.s13.setColor(context.greySwatch.shade700),
          ),
        ],
      ),
    );
  }
}
