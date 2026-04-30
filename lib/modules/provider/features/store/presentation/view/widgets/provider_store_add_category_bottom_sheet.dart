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
import '../../../../../../../../core/widgets/custom_text_field.dart';
import '../../controller/provider_store_cubit/provider_store_cubit.dart';
import 'provider_store_bottom_sheet_header.dart';

class ProviderStoreAddCategoryBottomSheet extends StatefulWidget {
  const ProviderStoreAddCategoryBottomSheet({super.key});

  @override
  State<ProviderStoreAddCategoryBottomSheet> createState() => _ProviderStoreAddCategoryBottomSheetState();
}

class _ProviderStoreAddCategoryBottomSheetState extends State<ProviderStoreAddCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
            ProviderStoreBottomSheetHeader(title: LocaleKeys.provider_store_sheets_add_category_title.tr()),
            24.gap,
            CustomTextField(
              controller: _nameController,
              title: LocaleKeys.provider_store_fields_category_name.tr(),
              hint: LocaleKeys.provider_store_fields_category_name.tr(),
              validator: Validator.validateRequired,
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

    context.read<ProviderStoreCubit>().addCategory(_nameController.text.trim());
    BaseRouter.pop();
    Toaster.showToast(LocaleKeys.provider_store_messages_category_added.tr(), isError: false);
  }
}
