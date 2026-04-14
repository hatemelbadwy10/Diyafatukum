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
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_phone_field.dart';
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgetPasswordCubit>(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) => state.status.listen(
          onFailed: (failure) => Toaster.showToast(failure.message),
          onSuccess: (code) => AppRoutes.verification.push(
            extra: {'type': VerificationType.forgetPassword},
            queries: {'code': code, 'identifier': _valueController.text},
          ),
        ),
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar.build(),
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.auth_password_forget.tr(), style: context.displaySmall.medium.s18),
                  8.gap,
                  Text(
                    LocaleKeys.auth_password_forget_subtitle.tr(),
                    style: context.bodyLarge.regular.s12,
                    textAlign: TextAlign.center,
                  ),
                  24.gap,
                  CustomPhoneField(controller: _valueController),
                  32.gap,
                  CustomButton(
                    isLoading: state.status.isLoading,
                    label: LocaleKeys.actions_next.tr(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ForgetPasswordCubit>().forgetPassword(_valueController.text.neglectStartingZero);
                      }
                    },
                  ).setHero(HeroTags.secondaryButton),
                ],
              ).withListView(),
            ),
          );
        },
      ),
    );
  }
}
