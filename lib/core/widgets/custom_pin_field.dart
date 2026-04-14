import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/config/theme/light_theme.dart';
import '../../core/config/extensions/all_extensions.dart';
import '../../core/utils/validators.dart';
import '../resources/resources.dart';

class CustomPinInputField extends StatelessWidget {
  const CustomPinInputField({super.key, this.onCompleted, required this.controller});
  final TextEditingController controller;
  final void Function(String)? onCompleted;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FormField(
        validator: (_) => Validator.validateOTP(controller.text),
        builder: (state) {
          return Column(
            children: [
              PinCodeTextField(
                length: 4,
                controller: controller,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                separatorBuilder: (context, index) => 12.gap,
                appContext: context,
                showCursor: false,
                obscureText: false,
                enableActiveFill: true,
                autoFocus: true,
                autoDismissKeyboard: true,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                enablePinAutofill: true,
                backgroundColor: context.scaffoldBackgroundColor,
                //* otp functionality *//
                onCompleted: onCompleted,
                //* text style *//
                textStyle: context.titleLarge.s28.medium,
                //* pin box properties *//
                pinTheme: PinTheme.defaults(
                  fieldHeight: 70,
                  fieldWidth: 70,
                  fieldOuterPadding: 4.edgeInsetsAll,
                  shape: PinCodeFieldShape.box,
                  borderRadius: AppSize.mainRadius.borderRadius,
                  activeFillColor: context.primaryContainerColor,
                  inactiveFillColor: context.fillColor,
                  selectedFillColor: context.fillColor,
                  //* border properties *//
                  borderWidth: 1,
                  activeBorderWidth: 1,
                  selectedBorderWidth: 1,
                  inactiveBorderWidth: 1,
                  selectedColor: context.primaryBorder,
                  activeColor: context.primaryColor,
                  inactiveColor: LightThemeColors.inputFieldBorder,
                ),
              ),
              if (state.hasError) Text(state.errorText!, style: context.errorStyle).paddingTop(8),
            ],
          );
        },
      ),
    );
  }
}
