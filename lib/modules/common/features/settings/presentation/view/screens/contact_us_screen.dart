import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/config/router/route_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';

import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_phone_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../controller/contact_us_cubit/contact_us_cubit.dart';
import '../../controller/contact_us_cubit/contact_us_mixin.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> with ContactUsMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContactUsCubit>(),
      child: BlocConsumer<ContactUsCubit, ContactUsState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) => state.status.listen(
          onFailed: (failure) => Toaster.showToast(failure.message),
          onSuccess: (data) {
            Toaster.showToast(data, isError: false);
            BaseRouter.pop();
          },
        ),
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar.build(titleText: LocaleKeys.settings_contact_title.tr()),
            bottomNavigationBar: CustomButton(
              isLoading: state.status.isLoading,
              label: LocaleKeys.actions_send.tr(),
              onPressed: () {
                if (validateForm()) {
                  context.read<ContactUsCubit>().contactUs(body);
                }
              },
            ).toBottomNavBar(bottom: context.keyboardPadding + 16),
            body: Form(
              key: formKey,
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: nameController,
                    title: LocaleKeys.details_name.tr(),
                    hint: LocaleKeys.details_name.tr().enterHint,
                    autovalidateMode: AutovalidateMode.disabled,
                  ),
                  CustomPhoneField(
                    showPrefixIcon: false,
                    controller: phoneController,
                    autovalidateMode: AutovalidateMode.disabled,
                  ),
                  CustomTextField(
                    inputType: InputType.email,
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.disabled,
                    title: LocaleKeys.details_contact_email.tr(),
                    hint: LocaleKeys.details_contact_email.tr().enterHint,
                  ),
                  CustomTextField(
                    maxLines: 5,
                    controller: messageController,
                    autovalidateMode: AutovalidateMode.disabled,
                    title: LocaleKeys.settings_contact_message.tr(),
                    hint: LocaleKeys.settings_contact_message.tr().enterHint,
                  ),
                  const SizedBox(),
                ],
              ).withListView(),
            ),
          );
        },
      ),
    );
  }
}
