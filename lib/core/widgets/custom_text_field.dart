import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/validators.dart';
import 'animated_slide_text.dart';
import 'custom_animated_container.dart';
import 'custom_input_field.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.hint,
    this.title,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.height,
    this.focusNode,
    this.onChanged,
    this.maxLines = 1,
    this.suffix,
    this.inputFormatters,
    this.inputType = InputType.text,
    this.isRequired = true,
    this.prefix,
    this.onSubmitted,
    this.iconConstraints,
    this.enableUnfocusOnEditingComplete = true,
    this.errorText,
    this.textAlign,
    this.autovalidateMode,
    this.onSaved,
    this.enabled = true,
    this.showRequiredIndicator = true,
    this.onTapUpOutside,
    this.borderRadius,
  });

  final Widget? prefix;
  final String? prefixIcon;
  final String? suffixIcon;
  final TextEditingController? controller;
  final String? hint;
  final String? title;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final bool readOnly;
  final bool enabled;
  final double? height;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final InputType inputType;
  final bool isRequired;
  final BoxConstraints? iconConstraints;
  final bool enableUnfocusOnEditingComplete;
  final String? errorText;
  final TextAlign? textAlign;
  final AutovalidateMode? autovalidateMode;
  final void Function(String?)? onSaved;
  final bool showRequiredIndicator;
  final void Function(PointerUpEvent)? onTapUpOutside;
  final double? borderRadius;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;
  final ValueNotifier<bool> _hasFocus = ValueNotifier<bool>(false);

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      _hasFocus.value = _focusNode.hasFocus || widget.controller?.text.isNotEmpty == true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _hasFocus,
      builder: (context, hasFocus, child) {
        return FormField(
          validator: _getValidator(),
          autovalidateMode: widget.autovalidateMode,
          builder: (FormFieldState<String> formState) {
            return CustomAnimatedContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField.filled(
                    autoFocus: false,
                    borderRadius: widget.borderRadius?.borderRadius,
                    showRequiredIndicator: widget.showRequiredIndicator,
                    enabled: widget.enabled,
                    autovalidateMode: widget.autovalidateMode,
                    borderEnabled: true,
                    isRequired: widget.isRequired,
                    inputType: widget.inputType,
                    readOnly: widget.readOnly,
                    height: widget.height,
                    gradientBorder: _gradientBorder(formState, hasFocus),
                    hint: widget.hint,
                    title: widget.title,
                    textAlign: widget.textAlign ?? TextAlign.start,
                    focusNode: widget.focusNode ?? _focusNode,
                    isPassword: widget.isPassword,
                    borderColor: _borderColor(formState, hasFocus, context),
                    controller: widget.controller,
                    inputFormatters: widget.inputFormatters,
                    keyboardType: widget.keyboardType,
                    maxLines: widget.maxLines,
                    onTapOutside: (_) => _focusNode.unfocus(),
                    suffixIcon:
                        widget.suffix ??
                        widget.suffixIcon?.toSvg(
                          color: hasFocus && widget.enabled ? context.primaryBorder : context.hintColor,
                          width: AppSize.iconNormal,
                          height: AppSize.iconNormal,
                        ),
                    iconConstraints: widget.iconConstraints,
                    errorText: widget.errorText,
                    prefixIcon:
                        widget.prefix ??
                        widget.prefixIcon?.toSvg(
                          color: hasFocus && widget.enabled ? context.primaryBorder : context.hintColor,
                          width: AppSize.iconNormal,
                          height: AppSize.iconNormal,
                        ),
                    onChanged: (value) {
                      widget.onChanged?.call(value);
                      formState.didChange(value);
                    },
                    onSubmitted: (value) {
                      widget.onSubmitted?.call(value);
                      formState.didChange(value);
                    },
                    onSaved: (value) {
                      widget.onSaved?.call(value);
                      formState.didChange(value);
                    },
                    onEditingComplete: () {
                      _focusNode.unfocus();
                      if (widget.enableUnfocusOnEditingComplete) {
                        widget.focusNode?.unfocus();
                      }
                    },
                    onTap: () {
                      _focusNode.requestFocus();
                      widget.onTap?.call();
                    },
                  ),
                  AnimatedSlideText(
                    isVisible: formState.hasError,
                    text: formState.errorText,
                    textStyle: context.inputFieldErrorTextStyle,
                    slideCurve: Curves.easeInOutExpo,
                    showFadeAnimation: formState.hasError,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _borderColor(FormFieldState<String> formState, bool enabled, BuildContext context) {
    if (formState.hasError) {
      return context.errorColor;
    } else if (enabled) {
      return context.primaryBorder;
    } else {
      return context.inputFieldBorderColor;
    }
  }

  Gradient? _gradientBorder(FormFieldState<String> formState, bool hasFocus) {
    if (formState.hasError || !widget.enabled || !hasFocus) {
      return null;
    }
    return GradientStyles.primaryGradient;
  }

  String? Function(String?)? _getValidator() {
    if (widget.validator != null) {
      return widget.validator;
    } else {
      switch (widget.inputType) {
        case InputType.name:
          return (_) => Validator.validateName(widget.controller!.text);
        case InputType.email:
          return (value) => Validator.validateEmail(widget.controller!.text, isRequired: widget.isRequired);
        case InputType.password:
          if (widget.isRequired) {
            return (_) => Validator.validateRequired(widget.controller!.text, title: widget.title, isRequired: true);
          } else {
            return (_) => Validator.validatePassword(widget.controller!.text);
          }
        case InputType.phone:
          return (value) => Validator.validatePhoneSa(widget.controller!.text);
        case InputType.url:
          return (_) => Validator.validateURL(widget.controller!.text);
        default:
          if (widget.validator != null) {
            return (_) => widget.validator!(widget.controller!.text);
          } else if (widget.isRequired) {
            return (_) => Validator.validateRequired(widget.controller?.text, title: widget.title, isRequired: true);
          }
      }
      return null;
    }
  }
}
