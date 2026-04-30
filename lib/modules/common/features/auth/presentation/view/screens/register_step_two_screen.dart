import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/geocoding_utils.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/utils/validators.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_check_box.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../settings/data/model/static_page_enum.dart';
import '../../../../verification/data/model/verification_type_enum.dart';
import '../../../data/model/register_response_model.dart';
import '../../controller/register_cubit/register_cubit.dart';
import '../widgets/auth_background_scaffold.dart';
import '../../../../addresses/presentation/view/screens/map_screen.dart';

class RegisterStepTwoScreen extends StatefulWidget {
  const RegisterStepTwoScreen({super.key, required this.args});

  final RegisterStepTwoArgs args;

  @override
  State<RegisterStepTwoScreen> createState() => _RegisterStepTwoScreenState();
}

class _RegisterStepTwoScreenState extends State<RegisterStepTwoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _isTermsAccepted = ValueNotifier<bool>(false);

  LatLng? _selectedLatLng;
  Placemark? _selectedPlacemark;

  @override
  void dispose() {
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isTermsAccepted.dispose();
    super.dispose();
  }

  Future<void> _openLocationPicker() async {
    await AppRoutes.map.push(
      extra: MapScreenArguments(
        initialPosition: _selectedLatLng,
        onLocationSelected: (LatLng position, Placemark placemark) {
          _selectedLatLng = position;
          _selectedPlacemark = placemark;
          _addressController.text = placemark.toAddressString();
          BaseRouter.pop();
          if (mounted) {
            setState(() {});
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _buildBody() async {
    return {
      'name': widget.args.name,
      'email': widget.args.email,
      'phone': widget.args.phone.neglectStartingZero,
      'address': _addressController.text.trim(),
      'latitude': _selectedLatLng!.latitude.toString(),
      'longitude': _selectedLatLng!.longitude.toString(),
      'password': _passwordController.text,
      'password_confirmation': _confirmPasswordController.text,
      'accept_terms': 1,
      'device_token': 'test',
      'preferred_locale': rootNavigatorKey.currentContext?.locale.languageCode ?? 'en',
    };
  }

  Future<void> _submit(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedLatLng == null || _selectedPlacemark == null) {
      Toaster.showToast(LocaleKeys.validator_location.tr());
      return;
    }
    if (!_isTermsAccepted.value) {
      Toaster.showToast(LocaleKeys.auth_register_accept_terms_required.tr());
      return;
    }
    if (!mounted) return;
    context.read<RegisterCubit>().register(await _buildBody());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RegisterCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) => state.status.listen(
          onSuccess: (data) {
            final registerResponse = data is RegisterResponseModel ? data : null;
            final identifier = registerResponse?.identifier ?? widget.args.phone;
            final otp = registerResponse?.otp;
            AppRoutes.verification.push(
              extra: {
                "type": VerificationType.register,
                "onVerificationSuccess": widget.args.onRegisterSuccess,
              },
              queries: {
                'identifier': identifier,
                if (otp?.isNotEmpty ?? false) 'code': otp,
              },
            );
          },
          onFailed: (failure) => Toaster.showToast(failure.message),
        ),
        builder: (context, state) {
          return AuthBackgroundScaffold(
            title: LocaleKeys.auth_register_complete_title.tr(),
            bottom: CustomButton.gradient(
              borderRadius: AppSize.buttonBorderRadius,
              isLoading: state.status.isLoading,
              label: LocaleKeys.auth_register_account.tr(),
              onPressed: () => _submit(context),
            ).setHero(HeroTags.mainButton),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.auth_register_complete_subtitle.tr(),
                    textAlign: TextAlign.center,
                    style: context.bodyLarge.regular.s13.setHeight(1.6),
                  ),
                  24.gap,
                  CustomTextField(
                    controller: _addressController,
                    showRequiredIndicator: false,
                    readOnly: true,
                    title: LocaleKeys.details_location_address.tr(),
                    hint: LocaleKeys.details_location_address.tr().enterHint,
                    suffixIcon: Assets.icons.ionLocationSharp.path,
                    onTap: _openLocationPicker,
                  ),
                  16.gap,
                  CustomTextField(
                    inputType: InputType.password,
                    controller: _passwordController,
                    showRequiredIndicator: false,
                    title: LocaleKeys.auth_password_title.tr(),
                    hint: LocaleKeys.auth_password_title.tr().enterHint,
                    prefixIcon: Assets.icons.weuiLockOutlined.path,
                  ),
                  16.gap,
                  CustomTextField(
                    inputType: InputType.password,
                    controller: _confirmPasswordController,
                    showRequiredIndicator: false,
                    title: LocaleKeys.auth_password_confirm.tr(),
                    hint: LocaleKeys.auth_password_confirm.tr().enterHint,
                    prefixIcon: Assets.icons.weuiLockOutlined.path,
                    validator: (value) =>
                        Validator.validateConfirmPassword(value, _passwordController.text),
                  ),
                  20.gap,
                  CustomCheckBox(
                    initialValue: _isTermsAccepted.value,
                    onChanged: (value) => _isTermsAccepted.value = value,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleKeys.auth_register_accept_terms_title.tr(),
                          style: context.bodyLarge.regular.s12,
                        ),
                        4.gap,
                        CustomTextButton(
                          label: LocaleKeys.settings_terms.tr(),
                          textStyle: context.displayLarge.regular.underline.s12,
                          onPressed: () => AppRoutes.staticPage.push(extra: StaticPage.terms),
                        ),
                      ],
                    ),
                  ),
                  16.gap,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RegisterStepTwoArgs {
  const RegisterStepTwoArgs({
    required this.name,
    required this.email,
    required this.phone,
    this.onRegisterSuccess,
  });

  final String name;
  final String email;
  final String phone;
  final void Function()? onRegisterSuccess;
}
