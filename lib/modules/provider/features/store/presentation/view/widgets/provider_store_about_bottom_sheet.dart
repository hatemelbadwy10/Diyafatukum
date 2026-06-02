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

class ProviderStoreAboutBottomSheet extends StatefulWidget {
  const ProviderStoreAboutBottomSheet({super.key, required this.store});

  final ProviderStoreModel store;

  @override
  State<ProviderStoreAboutBottomSheet> createState() =>
      _ProviderStoreAboutBottomSheetState();
}

class _ProviderStoreAboutBottomSheetState
    extends State<ProviderStoreAboutBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _aboutArController;
  late final TextEditingController _aboutEnController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _aboutArController = TextEditingController(
      text: widget.store.aboutDescription,
    );
    _aboutEnController = TextEditingController(
      text: widget.store.aboutDescription,
    );
  }

  @override
  void dispose() {
    _aboutArController.dispose();
    _aboutEnController.dispose();
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
              title: LocaleKeys.provider_store_sheets_about_title.tr(),
            ),
            24.gap,
            Row(
              children: [
                CustomTextField(
                  controller: _aboutArController,
                  title: LocaleKeys.provider_register_store_description_ar.tr(),
                  hint: LocaleKeys.provider_register_store_description_ar.tr(),
                  maxLines: 5,
                  validator: Validator.validateRequired,
                  inputType: InputType.text,
                ).expand(),
                16.gap,
                CustomTextField(
                  controller: _aboutEnController,
                  title: LocaleKeys.provider_register_store_description_en.tr(),
                  hint: LocaleKeys.provider_register_store_description_en.tr(),
                  maxLines: 5,
                  validator: Validator.validateRequired,
                  inputType: InputType.text,
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
    final failure = await context.read<ProviderStoreCubit>().updateAbout(
      ProviderStoreDescriptionRequestModel(
        descriptionAr: _aboutArController.text.trim(),
        descriptionEn: _aboutEnController.text.trim(),
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
}
