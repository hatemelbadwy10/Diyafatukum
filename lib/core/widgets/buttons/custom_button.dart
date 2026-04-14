import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/config/extensions/all_extensions.dart';
import '../../../core/config/theme/light_theme.dart';
import '../../../core/resources/resources.dart';
import 'button_styles_enums.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final ButtonType type;
  final ButtonColorScheme colorScheme;
  final ButtonBackgroundType? backgroundType;
  final ButtonContentType? contentType;
  final ButtonSize size;
  final ButtonShape shape;
  final ButtonBorderStyle style;
  final IconData? icon;
  final SvgGenImage? svg;
  final double? iconSize;
  final double? svgSize;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? fontColor;
  final TextStyle? textStyle;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final bool isLoading;
  final bool enabled;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    this.label = '',
    this.onPressed,
    this.type = ButtonType.elevated,
    this.contentType = ButtonContentType.text,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.stadium,
    this.style = ButtonBorderStyle.none,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.solid,
    this.icon,
    this.svg,
    this.iconSize,
    this.svgSize,
    this.width,
    this.height,
    this.fontSize,
    this.fontColor,
    this.textStyle,
    this.fontWeight,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.isLoading = false,
    this.enabled = true,
    this.gradient,
  });

  const CustomButton.icon({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
    this.type = ButtonType.elevated,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.stadium,
    this.style = ButtonBorderStyle.none,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.solid,
    this.iconSize,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.fontColor,
    this.fontSize,
    this.textStyle,
    this.fontWeight,
    this.isLoading = false,
    this.enabled = true,
    this.gradient,
  }) : contentType = ButtonContentType.icon,
       svg = null,
       svgSize = null;

  const CustomButton.svg({
    super.key,
    required this.label,
    required this.onPressed,
    required this.svg,
    this.size = ButtonSize.medium,
    this.type = ButtonType.elevated,
    this.shape = ButtonShape.stadium,
    this.style = ButtonBorderStyle.none,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.solid,
    this.svgSize,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.fontColor,
    this.fontSize,
    this.textStyle,
    this.fontWeight,
    this.isLoading = false,
    this.enabled = true,
    this.gradient,
  }) : contentType = ButtonContentType.svg,
       icon = null,
       iconSize = null;

  const CustomButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.text,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.stadium,
    this.style = ButtonBorderStyle.outlined,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.solid,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.fontColor,
    this.fontSize,
    this.textStyle,
    this.fontWeight,
    this.isLoading = false,
    this.enabled = true,
    this.gradient,
  }) : contentType = ButtonContentType.text,
       icon = null,
       iconSize = null,
       svg = null,
       svgSize = null;

  const CustomButton.stadium({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.text,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.stadium,
    this.style = ButtonBorderStyle.none,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.solid,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.fontColor,
    this.fontSize,
    this.textStyle,
    this.fontWeight,
    this.isLoading = false,
    this.enabled = true,
    this.gradient,
  }) : contentType = ButtonContentType.text,
       icon = null,
       iconSize = null,
       svg = null,
       svgSize = null;

  const CustomButton.gradient({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.elevated,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.stadium,
    this.style = ButtonBorderStyle.none,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.gradient,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.fontColor,
    this.fontSize,
    this.textStyle,
    this.fontWeight,
    this.isLoading = false,
    this.enabled = true,
    this.gradient,
  }) : contentType = ButtonContentType.text,
       icon = null,
       iconSize = null,
       svg = null,
       svgSize = null;

  const CustomButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.text,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.stadium,
    this.style = ButtonBorderStyle.outlined,
    this.colorScheme = ButtonColorScheme.destructive,
    this.backgroundType = ButtonBackgroundType.solid,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.fontColor,
    this.fontSize,
    this.textStyle,
    this.fontWeight,
    this.isLoading = false,
    this.enabled = true,
    this.gradient,
  }) : contentType = ButtonContentType.text,
       icon = null,
       iconSize = null,
       svg = null,
       svgSize = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressedCallback,
        style: context.elevatedButtonStyle.copyWith(
          textStyle: _getTextStyle(),
          foregroundColor: _getForegroundColor(),
          backgroundBuilder: backgroundType != null ? _getBackgroundBuilder : null,
          shape: _getButtonShape(shape),
          minimumSize: _getButtonSize(),
          backgroundColor: _getBackgroundColor(context),
        ),
        child: _getButtonContent(context),
      ),
    );
  }

  void Function()? get onPressedCallback {
    if (enabled) {
      return isLoading ? null : onPressed;
    }
    return null;
  }

  WidgetStateProperty<Size?>? _getButtonSize() {
    switch (size) {
      case ButtonSize.small:
        return WidgetStateProperty.all<Size>(Size(width ?? double.infinity, height ?? AppSize.buttonHeightSmall));
      case ButtonSize.medium:
        return WidgetStateProperty.all<Size>(Size(width ?? double.infinity, height ?? AppSize.buttonHeightMedium));
      case ButtonSize.large:
        return WidgetStateProperty.all<Size>(Size(width ?? double.infinity, height ?? AppSize.buttonHeightLarge));
    }
  }

  WidgetStateProperty<OutlinedBorder?>? _getButtonShape(ButtonShape shape) {
    switch (shape) {
      case ButtonShape.rounded:
        if (style == ButtonBorderStyle.none) {
          return WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? AppSize.buttonBorderRadius),
              side: BorderSide.none,
            ),
          );
        }
        return WidgetStateProperty.resolveWith<OutlinedBorder>((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? AppSize.buttonBorderRadius),
              side: BorderSide(color: _getBorderColor().withValues(alpha: 0.5)),
            );
          } else if (states.contains(WidgetState.disabled)) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? AppSize.buttonBorderRadius),
              side: BorderSide(color: LightThemeColors.disabledButton),
            );
          }
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? AppSize.buttonBorderRadius),
            side: BorderSide(color: _getBorderColor()),
          );
        });

      case ButtonShape.stadium:
        if (style == ButtonBorderStyle.none) {
          return WidgetStateProperty.all<OutlinedBorder>(StadiumBorder(side: BorderSide.none));
        }
        return WidgetStateProperty.resolveWith<OutlinedBorder>((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return StadiumBorder(side: BorderSide(color: _getBorderColor().withValues(alpha: 0.5)));
          } else if (states.contains(WidgetState.disabled)) {
            return StadiumBorder(side: BorderSide(color: LightThemeColors.disabledButton));
          }
          return StadiumBorder(side: BorderSide(color: _getBorderColor()));
        });
    }
  }

  Widget _getButtonContent(BuildContext context) {
    if (isLoading) {
      return CupertinoActivityIndicator(color: fontColor ?? Colors.white);
    }
    final value =
        contentType ??
        (icon != null
            ? ButtonContentType.icon
            : svg != null
            ? ButtonContentType.svg
            : ButtonContentType.text);

    switch (value) {
      case ButtonContentType.icon:
        return Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize ?? 16),
            if (label.isNotEmpty) ...[Text(label), SizedBox()],
          ],
        );
      case ButtonContentType.svg:
        return Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svg!.svg(height: svgSize ?? 16, width: svgSize ?? 16),
            if (label.isNotEmpty) Text(label),
            SizedBox(),
          ],
        );
      case ButtonContentType.text:
        return Text(label, maxLines: 1).fit().paddingDirectionalOnly(start: 8, end: 8 + (iconSize ?? 0));
    }
  }

  WidgetStateProperty<Color?>? _getBackgroundColor(BuildContext context) {
    switch (style) {
      case ButtonBorderStyle.none:
        return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return _getColorSchemeColor()?.withValues(alpha: 0.8);
          } else if (states.contains(WidgetState.disabled)) {
            return LightThemeColors.disabledButton;
          }
          return _getColorSchemeColor();
        });
      case ButtonBorderStyle.outlined:
        return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return _getColorSchemeColor()?.adjustBrightness();
          } else if (states.contains(WidgetState.disabled)) {
            return LightThemeColors.disabledButton;
          }
          return _getColorSchemeColor();
        });
    }
  }

  WidgetStateProperty<Color?>? _getForegroundColor() {
    return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return _getColorSchemeFontColor().withValues(alpha: 0.7);
      } else if (states.contains(WidgetState.disabled)) {
        return LightThemeColors.onPrimary;
      } else {
        return _getColorSchemeFontColor();
      }
    });
  }

  WidgetStateProperty<TextStyle?>? _getTextStyle() {
    return WidgetStateProperty.resolveWith<TextStyle?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return textStyle?.copyWith(
          color: _getColorSchemeFontColor().withValues(alpha: 0.8),
          fontSize: fontSize ?? textStyle?.fontSize ?? 14,
          fontWeight: fontWeight ?? textStyle?.fontWeight ?? FontWeight.w500,
        );
      } else {
        return textStyle?.copyWith(
          color: _getColorSchemeFontColor(),
          fontSize: fontSize ?? textStyle?.fontSize ?? 14,
          fontWeight: fontWeight ?? textStyle?.fontWeight ?? FontWeight.w500,
        );
      }
    });
  }

  Color? _getColorSchemeColor() {
    switch (colorScheme) {
      case ButtonColorScheme.primary:
        return backgroundColor ??
            (style == ButtonBorderStyle.outlined ? Colors.transparent : LightThemeColors.primary[600]!);
      case ButtonColorScheme.secondary:
        return LightThemeColors.secondary;
      case ButtonColorScheme.tertiary:
        return LightThemeColors.tertiary;
      case ButtonColorScheme.destructive:
        return LightThemeColors.error;
      case ButtonColorScheme.warning:
        return LightThemeColors.warning.shade100;
      case ButtonColorScheme.success:
        return LightThemeColors.success.shade100;
    }
  }

  Color _getColorSchemeBorderColor() {
    switch (colorScheme) {
      case ButtonColorScheme.primary:
        return borderColor ?? LightThemeColors.primary[600]!;
      case ButtonColorScheme.secondary:
        return LightThemeColors.secondary;
      case ButtonColorScheme.tertiary:
        return LightThemeColors.tertiary;
      case ButtonColorScheme.destructive:
        return LightThemeColors.error;
      case ButtonColorScheme.warning:
        return LightThemeColors.warning;
      case ButtonColorScheme.success:
        return LightThemeColors.success;
    }
  }

  Color _getColorSchemeFontColor() {
    switch (colorScheme) {
      case ButtonColorScheme.primary:
        return fontColor ??
            textStyle?.color ??
            (type == ButtonType.text ? LightThemeColors.primary[600]! : LightThemeColors.onPrimary);
      case ButtonColorScheme.secondary:
        return LightThemeColors.secondary;
      case ButtonColorScheme.tertiary:
        return LightThemeColors.tertiary;
      case ButtonColorScheme.destructive:
        return LightThemeColors.onPrimary;
      case ButtonColorScheme.warning:
        return LightThemeColors.warning;
      case ButtonColorScheme.success:
        return LightThemeColors.success;
    }
  }

  Color _getBorderColor() {
    switch (style) {
      case ButtonBorderStyle.none:
        return _getColorSchemeBorderColor();
      case ButtonBorderStyle.outlined:
        return _getColorSchemeBorderColor();
    }
  }

  Widget _getBackgroundBuilder(BuildContext context, Set<WidgetState> state, Widget? widget) {
    switch (backgroundType) {
      case ButtonBackgroundType.gradient:
        if (state.contains(WidgetState.pressed)) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient ?? GradientStyles.primaryGradientPressed,
              borderRadius: BorderRadius.circular(borderRadius ?? AppSize.buttonBorderRadius),
            ),
            child: widget,
          );
        } else if (state.contains(WidgetState.disabled)) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient ?? GradientStyles.disabledGradient,
              borderRadius: BorderRadius.circular(borderRadius ?? AppSize.buttonBorderRadius),
            ),
            child: widget,
          );
        } else {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient ?? GradientStyles.primaryGradient,
              borderRadius: BorderRadius.circular(borderRadius ?? AppSize.buttonBorderRadius),
            ),
            child: widget,
          );
        }

      default:
        return widget ?? const SizedBox.shrink();
    }
  }
}
