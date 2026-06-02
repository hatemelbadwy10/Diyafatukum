import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/utils/validators.dart';
import '../../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../../core/widgets/custom_selection_field.dart';
import '../../../../../../../../core/widgets/custom_text_field.dart';
import '../../../data/model/provider_store_model.dart';
import 'provider_store_bottom_sheet_header.dart';
import 'provider_store_add_product_bottom_sheet_mixin.dart';
import 'provider_store_product_image_picker.dart';

class ProviderStoreAddProductBottomSheet extends StatefulWidget {
  const ProviderStoreAddProductBottomSheet({
    super.key,
    required this.store,
    this.product,
    this.onSaved,
  });

  final ProviderStoreModel store;
  final ProviderStoreProductModel? product;
  final VoidCallback? onSaved;

  @override
  State<ProviderStoreAddProductBottomSheet> createState() =>
      _ProviderStoreAddProductBottomSheetState();
}

class _ProviderStoreAddProductBottomSheetState
    extends State<ProviderStoreAddProductBottomSheet>
    with ProviderStoreAddProductBottomSheetMixin {

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  @override
  void dispose() {
    disposeVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProviderStoreBottomSheetHeader(
              title: isEditing
                  ? LocaleKeys.provider_store_edit.tr()
                  : LocaleKeys.provider_store_sheets_add_product_title.tr(),
            ),
            24.gap,
            Row(
              children: [
                CustomTextField(
                  controller: nameArController,
                  title: LocaleKeys.localized_ar.tr(
                    args: [LocaleKeys.provider_store_fields_product_name.tr()],
                  ),
                  hint: LocaleKeys.localized_ar.tr(
                    args: [LocaleKeys.provider_store_fields_product_name.tr()],
                  ),
                  validator: Validator.validateRequired,
                  inputType: isEditing ? InputType.text : InputType.textAr,
                ).expand(),
                16.gap,
                CustomTextField(
                  controller: nameEnController,
                  title: LocaleKeys.localized_en.tr(
                    args: [LocaleKeys.provider_store_fields_product_name.tr()],
                  ),
                  hint: LocaleKeys.localized_en.tr(
                    args: [LocaleKeys.provider_store_fields_product_name.tr()],
                  ),
                  validator: Validator.validateRequired,
                  inputType: isEditing ? InputType.text : InputType.textEn,
                ).expand(),
              ],
            ),
            16.gap,
            Row(
              children: [
                CustomTextField(
                  controller: descriptionArController,
                  title: LocaleKeys.localized_ar.tr(
                    args: [LocaleKeys.details_description.tr()],
                  ),
                  hint: LocaleKeys.localized_ar.tr(
                    args: [LocaleKeys.details_description.tr()],
                  ),
                  validator: Validator.validateRequired,
                  inputType: isEditing ? InputType.text : InputType.textAr,
                  maxLines: 3,
                ).expand(),
                16.gap,
                CustomTextField(
                  controller: descriptionEnController,
                  title: LocaleKeys.localized_en.tr(
                    args: [LocaleKeys.details_description.tr()],
                  ),
                  hint: LocaleKeys.localized_en.tr(
                    args: [LocaleKeys.details_description.tr()],
                  ),
                  validator: Validator.validateRequired,
                  inputType: isEditing ? InputType.text : InputType.textEn,
                  maxLines: 3,
                ).expand(),
              ],
            ),
            16.gap,
            Row(
              children: [
                CustomTextField(
                  controller: priceController,
                  title: LocaleKeys.provider_store_fields_price.tr(),
                  hint: '0',
                  keyboardType: TextInputType.number,
                  validator: Validator.validateRequired,
                  inputType: InputType.number,
                ).expand(),
                16.gap,
                CustomTextField(
                  controller: quantityController,
                  title: LocaleKeys.provider_store_fields_quantity.tr(),
                  hint: '1',
                  keyboardType: TextInputType.number,
                  validator: Validator.validateRequired,
                  inputType: InputType.number,
                ).expand(),
              ],
            ),
            16.gap,
            CustomSelectionField<ProviderStoreCategoryModel>(
              title: LocaleKeys.provider_store_fields_product_category.tr(),
              hint: LocaleKeys.provider_store_fields_product_category.tr(),
              itemToString: (item) => item?.name ?? '',
              futureRequest: () => categories,
              onChanged: (value) {
                selectedCategoryId = value?.id;
              },
              initialValue: initialCategoryValue,
            ),
            16.gap,
            Text(
              LocaleKeys.provider_store_fields_product_image.tr(),
              style: context.titleMedium.medium,
            ),
            12.gap,
            ProviderStoreProductImagePicker(
              initialImagePath: imagePath,
              onChanged: (path) => imagePath = path,
            ),
            24.gap,
            ValueListenableBuilder<bool>(
              valueListenable: isSavingNotifier,
              builder: (context, isSaving, _) => CustomButton.gradient(
                borderRadius: 8,
                isLoading: isSaving,
                label: LocaleKeys.actions_save.tr(),
                onPressed: submit,
              ),
            ),
          ],
        ).paddingHorizontal(AppSize.screenPadding),
      ).paddingBottom(context.keyboardPadding),
    );
  }
}
