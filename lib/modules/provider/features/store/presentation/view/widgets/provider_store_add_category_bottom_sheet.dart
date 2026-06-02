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
import '../../../data/model/provider_store_request_model.dart';
import '../../controller/provider_store_cubit/provider_store_cubit.dart';
import 'provider_store_bottom_sheet_header.dart';

class ProviderStoreAddCategoryBottomSheet extends StatefulWidget {
  const ProviderStoreAddCategoryBottomSheet({super.key});

  @override
  State<ProviderStoreAddCategoryBottomSheet> createState() =>
      _ProviderStoreAddCategoryBottomSheetState();
}

class _ProviderStoreAddCategoryBottomSheetState
    extends State<ProviderStoreAddCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _descriptionEnController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
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
              title: LocaleKeys.provider_store_sheets_add_category_title.tr(),
            ),
            24.gap,
            Row(
              children: [
                CustomTextField(
                  controller: _nameArController,
                  title: LocaleKeys.localized_ar.tr(
                    args: [LocaleKeys.provider_store_fields_category_name.tr()],
                  ),
                  hint: LocaleKeys.localized_ar.tr(
                    args: [LocaleKeys.provider_store_fields_category_name.tr()],
                  ),
                  validator: Validator.validateRequired,
                  inputType: InputType.textAr,
                ).expand(),
                16.gap,
                CustomTextField(
                  controller: _nameEnController,
                  title: LocaleKeys.localized_en.tr(
                    args: [LocaleKeys.provider_store_fields_category_name.tr()],
                  ),
                  hint: LocaleKeys.localized_en.tr(
                    args: [LocaleKeys.provider_store_fields_category_name.tr()],
                  ),
                  validator: Validator.validateRequired,
                  inputType: InputType.textEn,
                ).expand(),
              ],
            ),
            16.gap,
            Row(
              children: [
                CustomTextField(
                  controller: _descriptionArController,
                  title: LocaleKeys.localized_ar.tr(
                    args: [LocaleKeys.details_description.tr()],
                  ),
                  hint: LocaleKeys.localized_ar.tr(
                    args: [LocaleKeys.details_description.tr()],
                  ),
                  validator: Validator.validateRequired,
                  inputType: InputType.textAr,
                  maxLines: 3,
                ).expand(),
                16.gap,
                CustomTextField(
                  controller: _descriptionEnController,
                  title: LocaleKeys.localized_en.tr(
                    args: [LocaleKeys.details_description.tr()],
                  ),
                  hint: LocaleKeys.localized_en.tr(
                    args: [LocaleKeys.details_description.tr()],
                  ),
                  validator: Validator.validateRequired,
                  inputType: InputType.textEn,
                  maxLines: 3,
                ).expand(),
              ],
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
    setState(() => _isSaving = true);
    final failure = await context.read<ProviderStoreCubit>().addCategory(
      ProviderStoreCategoryRequestModel(
        nameAr: _nameArController.text.trim(),
        nameEn: _nameEnController.text.trim(),
        descriptionAr: _descriptionArController.text.trim(),
        descriptionEn: _descriptionEnController.text.trim(),
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
      LocaleKeys.provider_store_messages_category_added.tr(),
      isError: false,
    );
  }
}
