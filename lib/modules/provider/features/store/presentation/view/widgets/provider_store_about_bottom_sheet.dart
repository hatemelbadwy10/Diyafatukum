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
import '../../../data/model/provider_store_model.dart';
import 'provider_store_bottom_sheet_header.dart';

class ProviderStoreAboutBottomSheet extends StatefulWidget {
  const ProviderStoreAboutBottomSheet({
    super.key,
    required this.store,
  });

  final ProviderStoreModel store;

  @override
  State<ProviderStoreAboutBottomSheet> createState() => _ProviderStoreAboutBottomSheetState();
}

class _ProviderStoreAboutBottomSheetState extends State<ProviderStoreAboutBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController(text: widget.store.aboutDescription);
  }

  @override
  void dispose() {
    _aboutController.dispose();
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
            ProviderStoreBottomSheetHeader(title: LocaleKeys.provider_store_sheets_about_title.tr()),
            24.gap,
            CustomTextField(
              controller: _aboutController,
              title: LocaleKeys.provider_store_fields_about.tr(),
              hint: LocaleKeys.provider_store_fields_about_hint.tr(),
              maxLines: 5,
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

    context.read<ProviderStoreCubit>().updateAbout(_aboutController.text.trim());
    BaseRouter.pop();
    Toaster.showToast(LocaleKeys.provider_store_messages_saved.tr(), isError: false);
  }
}
