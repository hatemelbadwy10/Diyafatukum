import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/utils/validators.dart';
import '../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../controller/password_cubit/password_cubit.dart';
import '../../controller/password_cubit/password_mixin.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() => _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> with PasswordMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PasswordCubit>(),
      child: BlocConsumer<PasswordCubit, PasswordState>(
        listener: (context, state) => state.status.listen(
          onFailed: (failure) => Toaster.showToast(failure.message),
          onSuccess: (_) {
            context.pop();
            resetForm();
            Toaster.showToast(state.status.message, isError: false);
          },
        ),
        builder: (context, state) {
          final cubit = context.read<PasswordCubit>();
          return CustomBottomSheet(
            title: LocaleKeys.auth_password_change.tr(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.auth_password_new.tr().enterHint,
                    style: context.displayMedium.regular.s14,
                    textAlign: TextAlign.center,
                  ),
                  24.gap,
                  CustomTextField(
                    isRequired: true,
                    inputType: InputType.password,
                    controller: oldPasswordController,
                    title: LocaleKeys.auth_password_old.tr(),
                    hint: LocaleKeys.auth_password_old.tr().enterHint,
                    prefixIcon: Assets.icons.eyeOutlined.path,
                  ),
                  16.gap,
                  CustomTextField(
                    isRequired: false,
                    inputType: InputType.password,
                    controller: passwordController,
                    title: LocaleKeys.auth_password_new.tr(),
                    hint: LocaleKeys.auth_password_new.tr().enterHint,
                    prefixIcon: Assets.icons.eyeOutlined.path,
                  ),
                  16.gap,
                  CustomTextField(
                    inputType: InputType.password,
                    controller: confirmPasswordController,
                    title: LocaleKeys.auth_password_confirm_new.tr(),
                    hint: LocaleKeys.auth_password_confirm_new.tr().enterHint,
                    prefixIcon: Assets.icons.eyeOutlined.path,
                    validator: (_) =>
                        Validator.validateConfirmPassword(passwordController.text, confirmPasswordController.text),
                  ),
                  32.gap,
                  CustomButton(
                    isLoading: state.status.isLoading,
                    label: LocaleKeys.actions_save.tr(),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.changePassword(body);
                      }
                    },
                  ).paddingBottom(context.keyboardPadding),
                ],
              ).paddingHorizontal(AppSize.screenPadding),
            ),
          );
        },
      ),
    );
  }
}
