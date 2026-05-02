import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_button.dart';
import '../../../../../../../core/widgets/close_icon_button.dart';
import '../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/widgets/date_picker_field.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../controller/bag_cubit/bag_cubit.dart';
import '../../../data/repository/bag_repository.dart';
import '../../../../addresses/presentation/view/widgets/addresses_bottom_sheet.dart';

class BagCheckoutBottomSheet extends StatefulWidget {
  const BagCheckoutBottomSheet({
    super.key,
    this.authCubit,
    required this.bagCubit,
  });

  final AuthCubit? authCubit;
  final BagCubit bagCubit;

  @override
  State<BagCheckoutBottomSheet> createState() => _BagCheckoutBottomSheetState();
}

class _BagCheckoutBottomSheetState extends State<BagCheckoutBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _addressController.text =
        widget.authCubit?.state.address?.fullAddress ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = CustomBottomSheet(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.greySwatch.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: CloseIconButton(onPressed: BaseRouter.pop),
                ),
                Text(
                  LocaleKeys.bag_checkout_title.tr(),
                  style: context.titleLarge.bold.s24,
                  textAlign: TextAlign.center,
                ).expand(),
                32.gap,
              ],
            ),
            12.gap,
            Text(
              LocaleKeys.bag_checkout_subtitle.tr(),
              style: context.bodyMedium.regular.setColor(
                context.greySwatch.shade600,
              ),
            ),
            24.gap,
            DatePickerField(
              title: LocaleKeys.details_date_time_date.tr(),
              minDate: DateTime.now(),
              initialValue: _selectedDate,
              onChanged: (value) => _selectedDate = value,
            ),
            20.gap,
            CustomTextField(
              controller: _addressController,
              title: LocaleKeys.bag_checkout_address_title.tr(),
              hint: LocaleKeys.bag_checkout_address_select.tr(),
              readOnly: widget.authCubit != null,
              prefixIcon: Assets.icons.ionLocationSharp.path,
              onTap: widget.authCubit == null
                  ? null
                  : () => context.showBottomSheet(
                      BlocProvider.value(
                        value: widget.authCubit!,
                        child: const AddressesBottomSheet(),
                      ),
                    ),
            ),
            20.gap,
            CustomTextField(
              controller: _notesController,
              title: LocaleKeys.bag_checkout_notes_title.tr(),
              hint: LocaleKeys.bag_checkout_notes_hint.tr(),
              prefixIcon: Assets.icons.editSquare.path,
              isRequired: false,
            ),
            24.gap,
            CustomButton(
              label: LocaleKeys.actions_confirm.tr(),
              onPressed: _submit,
            ),
          ],
        ).paddingHorizontal(AppSize.screenPadding),
      ).paddingBottom(context.keyboardPadding),
    );

    if (widget.authCubit == null) {
      return content;
    }

    return BlocListener<AuthCubit, AuthState>(
      bloc: widget.authCubit,
      listener: (_, state) {
        _addressController.text = state.address?.fullAddress ?? '';
      },
      child: content,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final selectedDate = _selectedDate;
    if (selectedDate == null) return;

    final result = await sl<BagRepository>().checkout({
      'delivery_address': _addressController.text.trim(),
      'delivery_latitude': widget.authCubit?.state.address?.lat ?? 0,
      'delivery_longitude': widget.authCubit?.state.address?.lng ?? 0,
      'occasion_date': selectedDate.format(
        format: 'yyyy-MM-dd HH:mm:ss',
        enableLocalization: false,
      ),
      'notes': _notesController.text.trim(),
    });

    if (!mounted) return;

    result.fold((failure) => Toaster.showToast(failure.message), (
      response,
    ) async {
      await widget.bagCubit.loadBag();
      widget.authCubit?.updateUserCartStoreId(null);
      if (!mounted) return;
      BaseRouter.pop();
      Toaster.showToast(
        response.message?.trim().isNotEmpty == true
            ? response.message!
            : LocaleKeys.bag_checkout_order_success_title.tr(),
        isError: false,
      );
    });
  }
}
