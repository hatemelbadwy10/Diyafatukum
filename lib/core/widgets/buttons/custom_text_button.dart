import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/config/extensions/all_extensions.dart';
import '../../../core/config/theme/light_theme.dart';
import '../../../core/resources/resources.dart';
import 'button_styles_enums.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
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
  final EdgeInsetsGeometry? padding;
  final bool alignIconEnd;
  final int? maxLines;
  final bool matchTextDirection;

  const CustomTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.contentType = ButtonContentType.text,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.rounded,
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
    this.padding,
    this.alignIconEnd = false,
    this.maxLines,
    this.matchTextDirection = false,
  });

  const CustomTextButton.icon({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.rounded,
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
    this.padding,
    this.alignIconEnd = false,
    this.maxLines,
    this.matchTextDirection = false,
  }) : contentType = ButtonContentType.icon,
       svg = null,
       svgSize = null;

  const CustomTextButton.svg({
    super.key,
    required this.label,
    required this.onPressed,
    required this.svg,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.rounded,
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
    this.padding,
    this.alignIconEnd = false,
    this.maxLines,
    this.matchTextDirection = false,
  }) : contentType = ButtonContentType.svg,
       icon = null,
       iconSize = null;

  const CustomTextButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.rounded,
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
    this.padding,
    this.alignIconEnd = false,
    this.maxLines,
    this.matchTextDirection = false,
  }) : contentType = ButtonContentType.text,
       icon = null,
       iconSize = null,
       svg = null,
       svgSize = null;

  const CustomTextButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.rounded,
    this.style = ButtonBorderStyle.none,
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
    this.padding,
    this.alignIconEnd = false,
    this.maxLines,
    this.matchTextDirection = false,
  }) : contentType = ButtonContentType.text,
       icon = null,
       iconSize = null,
       svg = null,
       svgSize = null;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressedCallback,
      style: context.textButtonStyle.copyWith(
        padding: padding != null ? WidgetStateProperty.all<EdgeInsetsGeometry>(padding!) : null,
        textStyle: _getTextStyle(),
        foregroundColor: _getForegroundColor(),
        foregroundBuilder: contentType == ButtonContentType.svg ? _getForegroundBuilder : null,
        backgroundBuilder: backgroundType != null ? _getBackgroundBuilder : null,
        shape: _getButtonShape(shape),
        backgroundColor: _getBackgroundColor(context),
      ),
      child: _getButtonContent(context),
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
      return CupertinoActivityIndicator(color: fontColor ?? Colors.white);
    }

    switch (contentType) {
      case ButtonContentType.icon:
        return Row(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize ?? 16),
            if (label.isNotEmpty) ...[Text(label, maxLines: maxLines, overflow: TextOverflow.ellipsis), SizedBox()],
          ],
        );
      case ButtonContentType.text:
        return Text(label, maxLines: maxLines, overflow: TextOverflow.ellipsis);
      default:
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
            return colorScheme == ButtonColorScheme.primary ? Colors.transparent : LightThemeColors.disabledButton;
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
        return _getColorSchemeFontColor().withValues(alpha: 0.5);
      } else if (states.contains(WidgetState.disabled)) {
        return LightThemeColors.disabledButton;
      }
      return _getColorSchemeFontColor();
    });
  }

  WidgetStateProperty<TextStyle?>? _getTextStyle() {
    return WidgetStateProperty.all<TextStyle?>(
      textStyle?.copyWith(
        color: _getColorSchemeFontColor(),
        fontSize: fontSize ?? textStyle?.fontSize ?? 14,
        fontWeight: fontWeight ?? textStyle?.fontWeight ?? FontWeight.w500,
      ),
    );
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

  Color _getColorSchemeFontColor() {
    switch (colorScheme) {
      case ButtonColorScheme.primary:
        return textStyle?.color ?? fontColor ?? LightThemeColors.primary[600]!;
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

  // use foreground builder for contentType svg
  Widget _getForegroundBuilder(BuildContext context, Set<WidgetState> state, Widget? widget) {
    if (contentType == ButtonContentType.svg) {
      if (isLoading) {
        return CupertinoActivityIndicator();
      }
      return Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (alignIconEnd) ...[
            SizedBox(),
            if (label.isNotEmpty)
              Text(label, maxLines: maxLines, overflow: TextOverflow.ellipsis).paddingTop(6).flexible(),
            svg!
                .svg(
                  height: svgSize ?? 16,
                  width: svgSize ?? 16,
                  colorFilter:
                      state.contains(WidgetState.pressed)
                          ? _getColorSchemeFontColor().withValues(alpha: 0.5).colorFilter
                          : _getColorSchemeFontColor().colorFilter,
                )
                .flipHorizontal(enable: matchTextDirection),
          ] else ...[
            svg!
                .svg(
                  height: svgSize ?? 16,
                  width: svgSize ?? 16,
                  colorFilter:
                      state.contains(WidgetState.pressed)
                          ? _getColorSchemeFontColor().withValues(alpha: 0.5).colorFilter
                          : _getColorSchemeFontColor().colorFilter,
                )
                .flipHorizontal(enable: matchTextDirection),
            if (label.isNotEmpty)
              Text(label, maxLines: maxLines, overflow: TextOverflow.ellipsis).paddingTop(6).flexible(),
            SizedBox(),
          ],
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
