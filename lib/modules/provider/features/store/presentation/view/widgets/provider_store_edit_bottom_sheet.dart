import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../../core/utils/validators.dart';
import '../../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../../core/widgets/custom_text_field.dart';
import '../../controller/provider_store_cubit/provider_store_cubit.dart';
import '../../../data/model/provider_store_model.dart';
import '../../../data/model/provider_store_request_model.dart';
import 'provider_store_bottom_sheet_header.dart';
import 'provider_store_image_picker.dart';

class ProviderStoreEditBottomSheet extends StatefulWidget {
  const ProviderStoreEditBottomSheet({super.key, required this.store});

  final ProviderStoreModel store;

  @override
  State<ProviderStoreEditBottomSheet> createState() =>
      _ProviderStoreEditBottomSheetState();
}

class _ProviderStoreEditBottomSheetState
    extends State<ProviderStoreEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameArController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _phoneController;
  late final TextEditingController _commercialRegistrationController;
  late final TextEditingController _addressController;
  late final TextEditingController _whatsAppController;
  late String _selectedCategoryName;
  late String _coverImagePath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(text: widget.store.name);
    _nameEnController = TextEditingController(text: widget.store.nameEn);
    _phoneController = TextEditingController(
      text: _normalizeSaudiPhone(widget.store.phone),
    );
    _commercialRegistrationController = TextEditingController(
      text: widget.store.commercialRegistrationNumber,
    );
    _addressController = TextEditingController(text: widget.store.location);
    _whatsAppController = TextEditingController(
      text: _normalizeSaudiPhone(widget.store.whatsapp),
    );
    _selectedCategoryName = widget.store.category;
    _coverImagePath = widget.store.coverImagePath;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _phoneController.dispose();
    _commercialRegistrationController.dispose();
    _addressController.dispose();
    _whatsAppController.dispose();
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
            ProviderStoreBottomSheetHeader(
              title: LocaleKeys.provider_store_sheets_edit_title.tr(),
            ),
            24.gap,
            ProviderStoreImagePicker(
              initialImagePath: _coverImagePath,
              onChanged: (path) => _coverImagePath = path,
            ).center(),
            28.gap,
            Row(
              children: [
                CustomTextField(
                  controller: _nameArController,
                  title: LocaleKeys.provider_store_fields_name_ar.tr(),
                  hint: LocaleKeys.provider_store_fields_name_ar.tr(),
                  validator: Validator.validateName,
                ).expand(),
                16.gap,
                CustomTextField(
                  controller: _nameEnController,
                  title: LocaleKeys.provider_store_fields_name_en.tr(),
                  hint: LocaleKeys.provider_store_fields_name_en.tr(),
                  validator: Validator.validateRequired,
                ).expand(),
              ],
            ),
            16.gap,
            CustomTextField(
              title: LocaleKeys.provider_store_fields_category.tr(),
              hint: LocaleKeys.provider_store_fields_category.tr(),
              controller: TextEditingController(text: _selectedCategoryName),
              readOnly: true,
            ),
            16.gap,
            CustomTextField(
              controller: _phoneController,
              title: LocaleKeys.details_contact_phone.tr(),
              hint: LocaleKeys.details_contact_phone.tr(),
              keyboardType: TextInputType.phone,
              validator: Validator.validatePhoneSa,
              inputType: InputType.phone,
            ),
            16.gap,
            CustomTextField(
              controller: _commercialRegistrationController,
              title: LocaleKeys.provider_register_commercial_register.tr(),
              hint: LocaleKeys.provider_register_commercial_register.tr(),
              validator: Validator.validateRequired,
            ),
            16.gap,
            CustomTextField(
              controller: _addressController,
              title: LocaleKeys.provider_store_fields_address.tr(),
              hint: LocaleKeys.provider_store_fields_address.tr(),
              prefixIcon: Assets.icons.locationPinDisabled.path,
              validator: Validator.validateRequired,
            ),
            16.gap,
            CustomTextField(
              controller: _whatsAppController,
              title: LocaleKeys.provider_store_fields_whatsapp.tr(),
              hint: LocaleKeys.provider_store_fields_whatsapp.tr(),
              prefixIcon: Assets.icons.whatsapp.path,
              keyboardType: TextInputType.phone,
              validator: Validator.validatePhoneSa,
            ),
            24.gap,
            CustomButton.gradient(
              borderRadius: 8,
              isLoading: _isSaving,
              label: LocaleKeys.actions_save.tr(),
              onPressed: _submit,
            ),
          ],
        ).paddingHorizontal(AppSize.screenPadding),
      ).paddingBottom(context.keyboardPadding),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final logo =
        (_coverImagePath.isNotEmpty &&
            !_coverImagePath.startsWith('http') &&
            !_coverImagePath.startsWith('assets/'))
        ? File(_coverImagePath)
        : null;
    setState(() => _isSaving = true);
    final failure = await context.read<ProviderStoreCubit>().updateStoreDetails(
      ProviderStoreUpdateRequestModel(
        phone: _buildSaudiPhone(_phoneController.text),
        commercialRegistrationNumber: _commercialRegistrationController.text
            .trim(),
        specializationId: widget.store.specializationId,
        address: _addressController.text.trim(),
        latitude: widget.store.latitude,
        longitude: widget.store.longitude,
        whatsapp: _buildSaudiPhone(_whatsAppController.text),
        nameAr: _nameArController.text.trim(),
        nameEn: _nameEnController.text.trim(),
        descriptionAr: widget.store.aboutDescription,
        descriptionEn: widget.store.aboutDescription,
        logo: logo,
      ),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (failure != null) {
      Toaster.showToast(failure.message);
      return;
    }
    BaseRouter.pop();
    Toaster.showToast(
      LocaleKeys.provider_store_messages_saved.tr(),
      isError: false,
    );
  }

  String _normalizeSaudiPhone(String value) {
    final normalized = value.trim().replaceAll(' ', '');
    if (normalized.startsWith('+966')) {
      return normalized.replaceFirst('+966', '').neglectStartingZero;
    }
    if (normalized.startsWith('966')) {
      return normalized.replaceFirst('966', '').neglectStartingZero;
    }
    return normalized.neglectStartingZero;
  }

  String _buildSaudiPhone(String value) {
    return '+966${value.trim().neglectStartingZero}';
  }
}
