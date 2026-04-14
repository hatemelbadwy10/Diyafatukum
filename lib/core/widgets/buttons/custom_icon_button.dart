import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/config/extensions/all_extensions.dart';
import '../../../core/config/theme/light_theme.dart';
import '../../../core/resources/resources.dart';
import 'button_styles_enums.dart';

class CustomIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final ButtonContentType contentType;
  final ButtonColorScheme colorScheme;
  final ButtonBackgroundType? backgroundType;
  final ButtonShape shape;
  final ButtonBorderStyle style;
  final IconData? icon;
  final SvgGenImage? svg;
  final double? size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final bool isLoading;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final bool matchTextDirection;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.contentType = ButtonContentType.icon,
    this.shape = ButtonShape.rounded,
    this.style = ButtonBorderStyle.none,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.solid,
    this.size,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.isLoading = false,
    this.enabled = true,
    this.padding,
    this.matchTextDirection = false,
  }) : svg = null;

  const CustomIconButton.svg({
    super.key,
    required this.svg,
    this.onPressed,
    this.size,
    this.contentType = ButtonContentType.svg,
    this.shape = ButtonShape.rounded,
    this.style = ButtonBorderStyle.none,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.solid,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.isLoading = false,
    this.enabled = true,
    this.padding,
    this.matchTextDirection = false,
  }) : icon = null;

  const CustomIconButton.outlinedIcon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size,
    this.contentType = ButtonContentType.icon,
    this.shape = ButtonShape.rounded,
    this.style = ButtonBorderStyle.outlined,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.solid,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.isLoading = false,
    this.enabled = true,
    this.padding,
    this.matchTextDirection = false,
  }) : svg = null;

  const CustomIconButton.outlinedSvg({
    super.key,
    required this.svg,
    required this.onPressed,
    this.contentType = ButtonContentType.svg,
    this.shape = ButtonShape.rounded,
    this.style = ButtonBorderStyle.outlined,
    this.colorScheme = ButtonColorScheme.primary,
    this.backgroundType = ButtonBackgroundType.solid,
    this.size,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.isLoading = false,
    this.enabled = true,
    this.padding,
    this.matchTextDirection = false,
  }) : icon = null;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressedCallback,
      style: context.textButtonStyle.copyWith(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(padding ?? 4.edgeInsetsAll),
        foregroundColor: _getForegroundColor(),
        foregroundBuilder: contentType == ButtonContentType.svg ? _getForegroundBuilder : null,
        shape: _getButtonShape(shape),
        backgroundColor: _getBackgroundColor(context),
      ),
      icon: _getButtonContent(context),
    );
  }

  void Function()? get onPressedCallback {
    if (enabled) {
      return isLoading ? null : onPressed;
    }
    return null;
  }

  WidgetStateProperty<OutlinedBorder?>? _getButtonShape(ButtonShape shape) {
    switch (shape) {
      case ButtonShape.rounded:
        if (style == ButtonBorderStyle.none) {
          return WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? AppSize.buttonBorderRadius)),
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
        return WidgetStateProperty.all<OutlinedBorder>(StadiumBorder(side: BorderSide(color: _getBorderColor())));
    }
  }

  Widget _getButtonContent(BuildContext context) {
    if (isLoading) {
      return CupertinoActivityIndicator(color: foregroundColor ?? Colors.white);
    }
    if (contentType == ButtonContentType.icon) {
      return Icon(icon, size: size ?? 16);
    } else {
      return SizedBox.shrink();
    }
  }

  WidgetStateProperty<Color?>? _getBackgroundColor(BuildContext context) {
    switch (style) {
      case ButtonBorderStyle.none:
        return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return _getColorSchemeColor()?.withValues(alpha: 0.5);
          } else if (states.contains(WidgetState.disabled)) {
            return LightThemeColors.disabledButton;
          }
          return _getColorSchemeColor();
        });
      case ButtonBorderStyle.outlined:
        return WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return _getColorSchemeColor()?.withValues(alpha: 0.5);
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
        return _getColorSchemeForegroundColor().withValues(alpha: 0.5);
      } else if (states.contains(WidgetState.disabled)) {
        return LightThemeColors.disabledButton;
      }
      return _getColorSchemeForegroundColor();
    });
  }

  Color? _getColorSchemeColor() {
    switch (colorScheme) {
      case ButtonColorScheme.primary:
        return backgroundColor;
      case ButtonColorScheme.secondary:
        return LightThemeColors.secondary;
      case ButtonColorScheme.tertiary:
        return LightThemeColors.tertiary;
      case ButtonColorScheme.destructive:
        return LightThemeColors.error.shade100;
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

  Color _getColorSchemeForegroundColor() {
    switch (colorScheme) {
      case ButtonColorScheme.primary:
        return foregroundColor ?? LightThemeColors.primary[600]!;
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

  Color _getBorderColor() {
    switch (style) {
      case ButtonBorderStyle.none:
        return _getColorSchemeBorderColor();
      case ButtonBorderStyle.outlined:
        return _getColorSchemeBorderColor();
    }
  }

  // use foreground builder for contentType svg
  Widget _getForegroundBuilder(BuildContext context, Set<WidgetState> state, Widget? widget) {
    if (contentType == ButtonContentType.svg) {
      return svg!.svg(
        height: size,
        width: size,
        matchTextDirection: matchTextDirection,
        colorFilter: state.contains(WidgetState.pressed)
            ? _getColorSchemeForegroundColor().withValues(alpha: 0.5).colorFilter
            : state.contains(WidgetState.disabled)
            ? LightThemeColors.grey[50]?.colorFilter
            : _getColorSchemeForegroundColor().colorFilter,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
