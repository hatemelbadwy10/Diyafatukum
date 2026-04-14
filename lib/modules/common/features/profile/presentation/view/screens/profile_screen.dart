import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/utils/toaster_utils.dart';

import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_phone_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';

import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../controller/profile_cubit/profile_cubit.dart';
import '../widgets/delete_account_bottom_sheet.dart';
import 'profile_mixin.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with ProfileMixin {
  @override
  void initState() {
    final auth = context.read<AuthCubit>().state.auth;
    init(auth.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) => state.status.listen(
          onFailed: (failure) => Toaster.showToast(failure.message),
          onSuccess: (user) {
            context.read<AuthCubit>().updateUserData(user);
            Toaster.showToast(state.status.message, isError: false);
            toggleEditing();
          },
        ),
        builder: (context, state) {
          return BlocConsumer<AuthCubit, AuthState>(
            listener: (context, authState) {
              init(authState.auth.user);
            },
            builder: (context, authState) {
              final auth = authState.auth;
              return ValueListenableBuilder(
                valueListenable: isEditingNotifier,
                builder: (context, isEditing, _) {
                  return Scaffold(
                    appBar: CustomAppBar.build(
                      titleText: LocaleKeys.account_profile_title.tr(),
                      actions: [
                        CustomTextButton.svg(
                          label: LocaleKeys.actions_edit.tr(),
                          onPressed: toggleEditing,
                          svg: Assets.icons.tablerEdit,
                        ).paddingEnd(16).visible(!isEditing),
                      ],
                    ),
                    bottomNavigationBar: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isEditing
                              ? CustomButton.gradient(
                                  isLoading: state.status.isLoading,
                                  label: LocaleKeys.actions_save_changes.tr(),
                                  onPressed: () async {
                                    if (isProfileUpdated(auth.user)) {
                                      toggleEditing();
                                    } else {
                                      if (isValidForm) {
                                        context.read<ProfileCubit>().updateProfile(body);
                                      }
                                    }
                                  },
                                )
                              : CustomButton.destructive(
                                  label: LocaleKeys.account_profile_delete_title.tr(),
                                  onPressed: () async {
                                    context.showBottomSheet(const DeleteAccountBottomSheet());
                                  },
                                ),
                        )
                            .setHero(HeroTags.mainButton)
                            .paddingHorizontal(AppSize.screenPadding)
                            .withSafeArea(minimum: 16.edgeInsetsVertical)
                            .paddingBottom(context.keyboardPadding),
                      ],
                    ),
                    body: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            enabled: isEditing,
                            inputType: InputType.name,
                            controller: nameController,
                            title: LocaleKeys.details_name.tr(),
                            hint: LocaleKeys.details_name.tr().enterHint,
                            prefixIcon: Assets.icons.iconoirProfileCircle.path,
                          ),
                          16.gap,
                          CustomPhoneField(
                            controller: phoneController,
                            enabled: false,
                            titleIcon: isEditing
                                ? CustomTextButton(
                                    label: "${LocaleKeys.actions_edit.tr()}>>",
                                    onPressed: () =>
                                        AppRoutes.phone.push(queries: {'identifier': auth.user.id.toString()}),
                                  )
                                : null,
                          ),
                          16.gap,
                          CustomTextField(
                            isRequired: false,
                            enabled: isEditing,
                            inputType: InputType.email,
                            controller: emailController,
                            title: LocaleKeys.details_contact_email.tr(),
                            hint: LocaleKeys.details_contact_email.tr().enterHint,
                            prefixIcon: Assets.icons.fluentMail28Regular.path,
                          ),
                        ],
                      ).withListView(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
