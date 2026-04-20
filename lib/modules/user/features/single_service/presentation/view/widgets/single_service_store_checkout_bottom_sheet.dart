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
import '../../../../../../common/features/bag/data/model/bag_model.dart';
import '../../../../../../common/features/bag/data/repository/bag_repository.dart';
import '../../../../../../common/features/addresses/presentation/view/widgets/addresses_bottom_sheet.dart';
import '../../../../../../common/features/auth/presentation/controller/auth_cubit/auth_cubit.dart';

class SingleServiceStoreCheckoutBottomSheet extends StatefulWidget {
  const SingleServiceStoreCheckoutBottomSheet({
    super.key,
    this.authCubit,
    required this.selectedItems,
  });

  final AuthCubit? authCubit;
  final List<BagItemModel> selectedItems;

  @override
  State<SingleServiceStoreCheckoutBottomSheet> createState() =>
      _SingleServiceStoreCheckoutBottomSheetState();
}

class _SingleServiceStoreCheckoutBottomSheetState
    extends State<SingleServiceStoreCheckoutBottomSheet> {
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
    return CustomBottomSheet(
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
                  LocaleKeys.home_user_store_booking_title.tr(),
                  style: context.titleLarge.bold.s24,
                  textAlign: TextAlign.center,
                ).expand(),
                32.gap,
              ],
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
              title: LocaleKeys.home_user_store_booking_notes_title.tr(),
              hint: LocaleKeys.home_user_store_booking_notes_hint.tr(),
              prefixIcon: Assets.icons.editSquare.path,
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
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await sl<BagRepository>().addItems(widget.selectedItems);
    BaseRouter.pop();
    Toaster.showToast(
      LocaleKeys.home_user_store_booking_success.tr(),
      isError: false,
    );
  }
}
