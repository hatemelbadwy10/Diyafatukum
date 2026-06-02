import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/utils/validators.dart';
import '../../../../../../../core/widgets/buttons/custom_button.dart';
import '../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../controller/orders_cubit/orders_cubit.dart';
import '../../../data/model/order_model.dart';

class ProviderOrderRejectBottomSheet extends StatefulWidget {
  const ProviderOrderRejectBottomSheet({super.key, required this.order});

  final OrderModel order;

  @override
  State<ProviderOrderRejectBottomSheet> createState() =>
      _ProviderOrderRejectBottomSheetState();
}

class _ProviderOrderRejectBottomSheetState
    extends State<ProviderOrderRejectBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _reasonController;
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: LocaleKeys.orders_details_actions_reject_title.tr(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.orders_details_actions_reject_message.tr(),
              style: context.bodyMedium.s14.setColor(
                context.colorScheme.onSurface,
              ),
            ),
            16.gap,
            CustomTextField(
              controller: _reasonController,
              title: LocaleKeys.orders_details_actions_reject_reason_title.tr(),
              hint: LocaleKeys.orders_details_actions_reject_reason_hint.tr(),
              inputType: InputType.text,
              maxLines: 3,
              validator: Validator.validateRequired,
            ),
            24.gap,
            ValueListenableBuilder<bool>(
              valueListenable: _isLoadingNotifier,
              builder: (context, isLoading, _) => CustomButton.destructive(
                isLoading: isLoading,
                label: LocaleKeys.orders_details_actions_reject_confirm.tr(),
                onPressed: _submit,
              ),
            ),
          ],
        ).paddingHorizontal(AppSize.screenPadding),
      ),
    ).paddingBottom(context.keyboardPadding);
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;

    _isLoadingNotifier.value = true;
    final failure = await context.read<OrdersCubit>().rejectProviderOrder(
      id: widget.order.backendId,
      reason: _reasonController.text.trim(),
    );
    if (!mounted) return;
    _isLoadingNotifier.value = false;

    if (failure != null) {
      Toaster.showToast(failure.message);
      return;
    }

    BaseRouter.pop(_reasonController.text.trim());
    Toaster.showToast(
      LocaleKeys.orders_details_actions_reject_success.tr(),
      isError: false,
    );
  }
}
