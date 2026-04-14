import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/config/theme/light_theme.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/input_formatters.dart';
import 'close_icon_button.dart';
import 'paste_icon_button.dart';

enum DecorationType { underlined, outlined, filled }

enum InputType { text, textAr, textEn, name, number, email, password, phone, url, price }

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    super.key,
    this.inputType = InputType.text,
    required this.decorationType,
    this.hasDropDown,
    this.text,
    required this.textInputAction,
    this.borderColor,
    this.width,
    this.onSubmitted,
    this.height,
    this.hint,
    this.hintColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.controller,
    required this.keyboardType,
    required this.isPassword,
    required this.enabled,
    required this.readOnly,
    required this.borderEnabled,
    required this.autoFocus,
    required this.smallSuffixIcon,
    required this.error,
    required this.isDense,
    required this.maxLines,
    this.borderRadius,
    this.fillColor,
    this.onChanged,
    this.label,
    this.title,
    this.autovalidateMode,
    this.contentPadding,
    required this.textAlign,
    this.hintTextStyle,
    this.labelStyle,
    this.textStyle,
    this.hintSize,
    required this.hasPoint,
    this.onTap,
    this.onEditingComplete,
    this.inputDecoration,
    this.focusNode,
    this.initialValue,
    this.background,
    this.gradientBorder,
    this.inputFormatters,
    this.isRequired = false,
    this.iconConstraints,
    this.errorText,
    this.onSaved,
    this.showRequiredIndicator = true,
    this.onTapUpOutside,
    this.onTapOutside,
  });

  final InputType inputType;
  final DecorationType decorationType;
  final bool? hasDropDown;
  final String? text;
  final TextInputAction textInputAction;
  final Color? borderColor;
  final double? width;
  final Function(String)? onSubmitted;
  final double? height;
  final String? hint;
  final Color? hintColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool enabled, readOnly, borderEnabled;
  final bool autoFocus;
  final bool smallSuffixIcon;
  final bool error;
  final bool isDense;
  final int? maxLines;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final Function(String)? onChanged;
  final String? label, title;
  final AutovalidateMode? autovalidateMode;
  final EdgeInsetsGeometry? contentPadding;
  final TextAlign textAlign;
  final TextStyle? hintTextStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final double? hintSize;
  final bool hasPoint;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final InputDecoration? inputDecoration;
  final FocusNode? focusNode;
  final String? initialValue;
  final Color? background;
  final Gradient? gradientBorder;
  final List<TextInputFormatter>? inputFormatters;
  final bool isRequired;
  final BoxConstraints? iconConstraints;
  final String? errorText;
  final void Function(String?)? onSaved;
  final bool showRequiredIndicator;
  final void Function(PointerUpEvent)? onTapUpOutside;
  final void Function(PointerDownEvent)? onTapOutside;

  const CustomInputField.underlined({
    super.key,
    this.inputType = InputType.text,
    this.hasDropDown = false,
    this.text,
    this.textInputAction = TextInputAction.done,
    this.borderColor,
    this.width,
    this.onSubmitted,
    this.height,
    this.hint,
    this.hintColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.enabled = true,
    this.readOnly = false,
    this.borderEnabled = true,
    this.autoFocus = false,
    this.smallSuffixIcon = false,
    this.error = false,
    this.isDense = false,
    this.maxLines = 1,
    this.borderRadius,
    this.fillColor,
    this.onChanged,
    this.label,
    this.title,
    this.autovalidateMode,
    this.contentPadding,
    this.textAlign = TextAlign.start,
    this.hintTextStyle,
    this.labelStyle,
    this.textStyle,
    this.hintSize,
    this.hasPoint = false,
    this.onTap,
    this.onEditingComplete,
    this.inputDecoration,
    this.focusNode,
    this.initialValue,
    this.background,
    this.gradientBorder,
    this.inputFormatters,
    this.isRequired = false,
    this.iconConstraints,
    this.errorText,
    this.onSaved,
    this.showRequiredIndicator = true,
    this.onTapUpOutside,
    this.onTapOutside,
  }) : decorationType = DecorationType.underlined;

  const CustomInputField.filled({
    super.key,
    this.inputType = InputType.text,
    this.hasDropDown = false,
    this.text,
    this.textInputAction = TextInputAction.done,
    this.borderColor,
    this.width,
    this.onSubmitted,
    this.height,
    this.hint,
    this.hintColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.enabled = true,
    this.readOnly = false,
    this.borderEnabled = true,
    this.autoFocus = false,
    this.smallSuffixIcon = false,
    this.error = false,
    this.isDense = false,
    this.maxLines = 1,
    this.borderRadius,
    this.fillColor,
    this.onChanged,
    this.label,
    this.title,
    this.autovalidateMode,
    this.contentPadding,
    this.textAlign = TextAlign.start,
    this.hintTextStyle,
    this.labelStyle,
    this.textStyle,
    this.hintSize,
    this.hasPoint = false,
    this.onTap,
    this.onEditingComplete,
    this.inputDecoration,
    this.focusNode,
    this.initialValue,
    this.background,
    this.gradientBorder,
    this.inputFormatters,
    this.isRequired = false,
    this.iconConstraints,
    this.errorText,
    this.onSaved,
    this.showRequiredIndicator = true,
    this.onTapUpOutside,
    this.onTapOutside,
  }) : decorationType = DecorationType.filled;

  const CustomInputField.outlined({
    super.key,
    this.inputType = InputType.text,
    this.hasDropDown = false,
    this.text,
    this.textInputAction = TextInputAction.done,
    this.borderColor,
    this.width,
    this.onSubmitted,
    this.height,
    this.hint,
    this.hintColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.enabled = true,
    this.readOnly = false,
    this.borderEnabled = true,
    this.autoFocus = false,
    this.smallSuffixIcon = false,
    this.error = false,
    this.isDense = false,
    this.maxLines = 1,
    this.borderRadius,
    this.fillColor,
    this.onChanged,
    this.label,
    this.title,
    this.autovalidateMode,
    this.contentPadding,
    this.textAlign = TextAlign.start,
    this.hintTextStyle,
    this.labelStyle,
    this.textStyle,
    this.hintSize,
    this.hasPoint = false,
    this.onTap,
    this.onEditingComplete,
    this.inputDecoration,
    this.focusNode,
    this.initialValue,
    this.background,
    this.gradientBorder,
    this.inputFormatters,
    this.isRequired = false,
    this.iconConstraints,
    this.errorText,
    this.onSaved,
    this.showRequiredIndicator = true,
    this.onTapUpOutside,
    this.onTapOutside,
  }) : decorationType = DecorationType.outlined;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final ValueNotifier<bool> obscure = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscure,
      builder: (context, obscuredValue, _) {
        return TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          onSaved: widget.onSaved,
          style:
              widget.textStyle ?? (widget.enabled ? context.inputFieldTextStyle : context.inputFieldDisabledTextStyle),
          onFieldSubmitted: widget.onSubmitted,
          textInputAction: widget.textInputAction,
          cursorErrorColor: context.errorColor,
          cursorColor: context.primaryColor,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          keyboardType: _getKeyboardType(),
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          onTapOutside: widget.onTapOutside ?? (_) => FocusScope.of(context).unfocus(),
          autofocus: widget.autoFocus,
          obscureText: widget.inputType == InputType.password && obscuredValue,
          enableSuggestions: widget.isPassword,
          autocorrect: widget.isPassword,
          autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          textAlign: widget.textAlign,
          onEditingComplete: widget.onEditingComplete,
          focusNode: widget.focusNode,
          onTap: widget.onTap,
          onTapUpOutside: widget.onTapUpOutside,
          inputFormatters: _getInputFormatters(),
          decoration: InputDecoration(
            hintText: widget.hint,
            labelText: widget.label,
            isDense: widget.isDense,
            errorText: widget.errorText,
            fillColor: _getBackgroundColor(),
            constraints: widget.height != null ? BoxConstraints(maxHeight: widget.height!) : null,
            labelStyle: widget.labelStyle ?? context.hintTextStyle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            hintStyle: context.hintTextStyle.copyWith(color: widget.hintColor),
            border: _buildInputBorder(borderColor: widget.borderColor),
            focusedBorder: _buildInputBorder(borderColor: widget.borderColor ?? context.primaryColor),
            enabledBorder: _buildInputBorder(borderColor: widget.borderColor ?? LightThemeColors.inputFieldBorder),
            errorBorder: _buildInputBorder(borderColor: context.errorColor),
            focusedErrorBorder: _buildInputBorder(borderColor: context.errorColor),
            prefixIconConstraints: widget.iconConstraints,
            suffixIconConstraints: widget.smallSuffixIcon ? const BoxConstraints(maxWidth: AppSize.iconNormal) : null,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(obscuredValue),
          ),
        ).setTitle(titleWidget: _getTitleWidget());
      },
    );
  }

  Widget? _getTitleWidget() {
    if (widget.title != null) {
      return RichText(
        text: TextSpan(
          children: [
            if (widget.showRequiredIndicator && widget.isRequired)
              TextSpan(text: '* ', style: context.errorStyle.regular.s14),
            TextSpan(text: widget.title!, style: widget.labelStyle ?? context.titleLarge.s14.regular),
          ],
        ),
      );
    }
    return null;
  }

  InputBorder _buildInputBorder({Color? borderColor}) {
    switch (widget.decorationType) {
      case DecorationType.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor ?? LightThemeColors.inputFieldBorder),
        );
      case DecorationType.outlined:
        return OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(AppSize.inputBorderRadius),
          borderSide: BorderSide(color: widget.borderColor ?? LightThemeColors.inputFieldBorder),
        );
      case DecorationType.filled:
        return OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(AppSize.inputBorderRadius),
          borderSide: widget.borderColor != null ? BorderSide(color: widget.borderColor!) : BorderSide.none,
        );
    }
  }

  Color _getBackgroundColor() {
    switch (widget.decorationType) {
      case DecorationType.underlined:
        return widget.background ?? context.scaffoldBackgroundColor;
      case DecorationType.outlined:
        return widget.background ?? context.scaffoldBackgroundColor;
      case DecorationType.filled:
        return widget.background ?? LightThemeColors.background;
    }
  }

  Widget? _buildSuffixIcon(bool obscuredValue) {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    } else if (widget.inputType == InputType.password) {
      return _buildVisibilityIcon(obscuredValue);
    } else if (widget.inputType == InputType.url) {
      return widget.controller?.text == '' ? _buildPasteIcon() : _buildClearIcon();
    }
    return null;
  }

  Widget _buildVisibilityIcon(bool obscuredValue) {
    return obscuredValue
        ? Assets.icons.eyeOn.path
              .toSvg(color: LightThemeColors.hintText)
              .onTap(() => obscure.value = !obscuredValue, borderRadius: 100.borderRadius)
        : Assets.icons.eyeOff.path
              .toSvg(color: LightThemeColors.hintText)
              .onTap(() => obscure.value = !obscuredValue, borderRadius: 100.borderRadius);
  }

  Widget? _buildClearIcon() {
    if (widget.controller == null) return null;
    return CloseIconButton(onPressed: () => widget.controller!.clear());
  }

  Widget? _buildPasteIcon() {
    if (widget.controller == null) return null;
    return PasteIconButton(onPressed: (text) => widget.controller?.text = text);
  }

  TextInputType? _getKeyboardType() {
    switch (widget.inputType) {
      case InputType.text:
        return TextInputType.text;
      case InputType.textAr:
        return TextInputType.text;
      case InputType.textEn:
        return TextInputType.text;
      case InputType.name:
        return TextInputType.text;
      case InputType.number:
        return TextInputType.number;
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.password:
        return TextInputType.visiblePassword;
      case InputType.phone:
        return TextInputType.phone;
      case InputType.url:
        return TextInputType.url;
      case InputType.price:
        return TextInputType.number;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.inputType) {
      case InputType.textAr:
        return [ArabicInputFormatter(allowSpace: true)];
      case InputType.textEn:
        return [EnglishInputFormatter(allowSpace: true)];
      case InputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case InputType.phone:
        return [FilteringTextInputFormatter.allow(RegExp('[0-9]'))];
      case InputType.price:
        return [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))];
      default:
        return widget.inputFormatters;
    }
  }
}
