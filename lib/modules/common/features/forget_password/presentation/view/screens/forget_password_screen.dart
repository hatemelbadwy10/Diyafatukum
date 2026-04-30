import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../auth/presentation/view/widgets/auth_background_scaffold.dart';
import '../../../../verification/data/model/verification_type_enum.dart';
import '../../controller/forget_password_cubit/forget_password_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _valueController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgetPasswordCubit>(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) => state.status.listen(
          onFailed: (failure) => Toaster.showToast(failure.message),
          onSuccess: (identifier) => AppRoutes.verification.push(
            extra: {'type': VerificationType.forgetPassword},
            queries: {
              'identifier': identifier,
            },
          ),
        ),
        builder: (context, state) {
          return AuthBackgroundScaffold(
            title: LocaleKeys.auth_password_forget.tr(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.auth_password_forget_subtitle.tr(),
                    style: context.bodyLarge.regular.s13.setHeight(1.6),
                  ),
                  24.gap,
                  CustomTextField(
                    controller: _valueController,
                    showRequiredIndicator: false,
                    inputType: InputType.email,
                    title: LocaleKeys.details_contact_email.tr(),
                    hint: LocaleKeys.details_contact_email.tr().enterHint,
                    prefixIcon: Assets.icons.mail.path,
                  ),
                  28.gap,
                  CustomButton.gradient(
                    borderRadius: AppSize.buttonBorderRadius,
                    isLoading: state.status.isLoading,
                    label: LocaleKeys.actions_next.tr(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ForgetPasswordCubit>().forgetPassword(
                          _valueController.text,
                        );
                      }
                    },
                  ).setHero(HeroTags.mainButton),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
