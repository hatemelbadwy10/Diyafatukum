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
import 'provider_store_product_image_picker.dart';

class ProviderStoreAddProductBottomSheet extends StatefulWidget {
  const ProviderStoreAddProductBottomSheet({
    super.key,
    required this.store,
  });

  final ProviderStoreModel store;

  @override
  State<ProviderStoreAddProductBottomSheet> createState() => _ProviderStoreAddProductBottomSheetState();
}

class _ProviderStoreAddProductBottomSheetState extends State<ProviderStoreAddProductBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  String? _selectedCategoryId;
  String _imagePath = 'assets/images/home_banner.png';

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.store.categories.where((category) => category.id != 'all').toList();

    return CustomBottomSheet(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProviderStoreBottomSheetHeader(title: LocaleKeys.provider_store_sheets_add_product_title.tr()),
            24.gap,
            CustomTextField(
              controller: _nameController,
              title: LocaleKeys.provider_store_fields_product_name.tr(),
              hint: LocaleKeys.provider_store_fields_product_name.tr(),
              validator: Validator.validateRequired,
            ),
            16.gap,
            CustomTextField(
              controller: _priceController,
              title: LocaleKeys.provider_store_fields_price.tr(),
              hint: '0',
              keyboardType: TextInputType.number,
              validator: Validator.validateRequired,
            ),
            16.gap,
            CustomSelectionField<ProviderStoreCategoryModel>(
              title: LocaleKeys.provider_store_fields_product_category.tr(),
              hint: LocaleKeys.provider_store_fields_product_category.tr(),
              itemToString: (item) => item?.name ?? '',
              futureRequest: () => categories,
              onChanged: (value) {
                _selectedCategoryId = value?.id;
              },
              initialValue: categories.isNotEmpty ? categories.first : null,
            ),
            16.gap,
            Text(
              LocaleKeys.provider_store_fields_product_image.tr(),
              style: context.titleMedium.medium,
            ),
            12.gap,
            ProviderStoreProductImagePicker(
              initialImagePath: _imagePath,
              onChanged: (path) => _imagePath = path,
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

    final categories = widget.store.categories.where((category) => category.id != 'all').toList();
    final fallbackCategory = categories.isNotEmpty ? categories.first : null;
    final categoryId = _selectedCategoryId ?? fallbackCategory?.id;

    if (categoryId == null) {
      Toaster.showToast(LocaleKeys.provider_store_fields_product_category.tr());
      return;
    }

    context.read<ProviderStoreCubit>().addProduct(
          name: _nameController.text.trim(),
          price: double.tryParse(_priceController.text.trim()) ?? 0,
          categoryId: categoryId,
          imagePath: _imagePath,
        );
    BaseRouter.pop();
    Toaster.showToast(LocaleKeys.provider_store_messages_product_added.tr(), isError: false);
  }
}
