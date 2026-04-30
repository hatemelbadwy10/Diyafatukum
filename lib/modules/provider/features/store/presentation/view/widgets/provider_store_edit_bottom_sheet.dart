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
import '../../../../../../../../core/widgets/custom_selection_field.dart';
import '../../../../../../../../core/widgets/custom_text_field.dart';
import '../../controller/provider_store_cubit/provider_store_cubit.dart';
import '../../../data/model/provider_store_model.dart';
import 'provider_store_bottom_sheet_header.dart';
import 'provider_store_image_picker.dart';

class ProviderStoreEditBottomSheet extends StatefulWidget {
  const ProviderStoreEditBottomSheet({
    super.key,
    required this.store,
  });

  final ProviderStoreModel store;

  @override
  State<ProviderStoreEditBottomSheet> createState() => _ProviderStoreEditBottomSheetState();
}

class _ProviderStoreEditBottomSheetState extends State<ProviderStoreEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameArController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _addressController;
  late final TextEditingController _whatsAppController;
  late String _selectedCategory;
  late String _coverImagePath;

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(text: widget.store.name);
    _nameEnController = TextEditingController(text: widget.store.nameEn);
    _addressController = TextEditingController(text: widget.store.location);
    _whatsAppController = TextEditingController(text: widget.store.whatsapp);
    _selectedCategory = widget.store.category;
    _coverImagePath = widget.store.coverImagePath;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _addressController.dispose();
    _whatsAppController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.store.categories
        .where((category) => category.id != 'all')
        .map((e) => e.name)
        .toList();

    return CustomBottomSheet(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProviderStoreBottomSheetHeader(title: LocaleKeys.provider_store_sheets_edit_title.tr()),
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
            CustomSelectionField<String>(
              title: LocaleKeys.provider_store_fields_category.tr(),
              hint: LocaleKeys.provider_store_fields_category.tr(),
              initialValue: _selectedCategory,
              itemToString: (value) => value ?? '',
              futureRequest: () => categories,
              onChanged: (value) => _selectedCategory = value ?? _selectedCategory,
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
              label: LocaleKeys.actions_save.tr(),
              onPressed: _submit,
            ),
          ],
        ).paddingHorizontal(AppSize.screenPadding),
      ).paddingBottom(context.keyboardPadding),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ProviderStoreCubit>().updateStoreDetails(
          nameAr: _nameArController.text.trim(),
          nameEn: _nameEnController.text.trim(),
          category: _selectedCategory,
          location: _addressController.text.trim(),
          whatsapp: _whatsAppController.text.trim(),
          coverImagePath: _coverImagePath,
        );
    BaseRouter.pop();
    Toaster.showToast(LocaleKeys.provider_store_messages_saved.tr(), isError: false);
  }
}
