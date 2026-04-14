import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_phone_field.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../verification/data/model/verification_type_enum.dart';
import '../../controller/phone_cubit/phone_cubit.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    _phoneController.text = context.read<AuthCubit>().state.user.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    return BlocProvider(
      create: (context) => sl<PhoneCubit>(),
      child: BlocConsumer<PhoneCubit, PhoneState>(
        listener: (context, state) => state.status.listen(
          onFailed: (failure) => Toaster.showToast(failure.message),
          onSuccess: (_) => AppRoutes.verification.push(
            queries: {'identifier': _phoneController.text},
            extra: {'type': VerificationType.changePhone},
          ),
        ),
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar.build(),
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: _phoneController,
              builder: (context, _, _) {
                final enabled = _phoneController.text != user.phone;
                return CustomButton.gradient(
                  isLoading: state.status.isLoading,
                  label: LocaleKeys.actions_save.tr(),
                  onPressed: !enabled
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<PhoneCubit>().changePhone(_phoneController.text);
                          }
                        },
                ).toBottomNavBar(bottom: context.keyboardPadding + 8);
              },
            ),
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.account_profile_change_phone_title.tr(), style: context.displaySmall.regular.s18),
                  8.gap,
                  Text(LocaleKeys.account_profile_change_phone_subtitle.tr(), style: context.bodyLarge.regular.s12),
                  24.gap,
                  CustomPhoneField(controller: _phoneController),
                ],
              ).withListView(),
            ),
          );
        },
      ),
    );
  }
}
