import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/config/extensions/all_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../controller/delete_account_cubit/delete_account_cubit.dart';

class DeleteAccountBottomSheet extends StatefulWidget {
  const DeleteAccountBottomSheet({super.key});

  @override
  State<DeleteAccountBottomSheet> createState() => _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState extends State<DeleteAccountBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeleteAccountCubit>(),
      child: BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, state) => state.status.listen(
          onFailed: (failure) => Toaster.showToast(failure.message),
          onSuccess: (_) {
            AppRoutes.login.go();
            context.read<AuthCubit>().clearAuthData();
            Toaster.showToast(state.status.message, isError: false);
          },
        ),
        builder: (context, state) {
          return CustomBottomSheet(
            title: LocaleKeys.account_profile_delete_title.tr(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.account_profile_delete_subtitle.tr(), style: context.bodyMedium.s14),
                  16.gap,
                  CustomTextField(
                    isRequired: true,
                    inputType: InputType.password,
                    controller: _passwordController,
                    title: LocaleKeys.auth_password_title.tr(),
                    hint: LocaleKeys.auth_password_title.tr().enterHint,
                  ),
                  32.gap,
                  CustomButton.destructive(
                    isLoading: state.status.isLoading,
                    label: LocaleKeys.actions_delete.tr(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<DeleteAccountCubit>().deleteAccount(_passwordController.text);
                      }
                    },
                  ),
                ],
              ).paddingHorizontal(AppSize.screenPadding),
            ),
          ).paddingBottom(context.keyboardPadding);
        },
      ),
    );
  }
}
