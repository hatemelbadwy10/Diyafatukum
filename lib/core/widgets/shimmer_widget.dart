import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppSize.mainRadius,
    this.shapeBorder = const RoundedRectangleBorder(),
    this.radius = 0,
    this.child,
    this.baseColor,
    this.highlightColor,
    this.enableShimmer = true,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  final double radius;
  final ShapeBorder shapeBorder;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enableShimmer;
  final Duration duration;

  const ShimmerWidget.circular({
    super.key,
    required this.radius,
    this.child,
    this.baseColor,
    this.highlightColor,
    this.enableShimmer = true,
    this.duration = const Duration(milliseconds: 1500),
  }) : width = radius * 2,
       height = radius * 2,
       borderRadius = radius,
       shapeBorder = const CircleBorder();

  const ShimmerWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppSize.mainRadius,
    this.shapeBorder = const RoundedRectangleBorder(),
    this.child,
    this.baseColor,
    this.highlightColor,
    this.enableShimmer = true,
    this.duration = const Duration(milliseconds: 1500),
  }) : radius = 0;

  // Factory constructor for square shimmer
  factory ShimmerWidget.square({
    Key? key,
    required double size,
    double borderRadius = AppSize.mainRadius,
    Widget? child,
    Color? baseColor,
    Color? highlightColor,
    bool enableShimmer = true,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return ShimmerWidget.rectangular(
      key: key,
      width: size,
      height: size,
      borderRadius: borderRadius,
      baseColor: baseColor,
      highlightColor: highlightColor,
      enableShimmer: enableShimmer,
      duration: duration,
      child: child,
    );
  }

  // Factory constructor for list item shimmer
  factory ShimmerWidget.listItem({
    Key? key,
    double width = double.infinity,
    double height = 60,
    double borderRadius = AppSize.mainRadius,
    Widget? child,
    Color? baseColor,
    Color? highlightColor,
    bool enableShimmer = true,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return ShimmerWidget.rectangular(
      key: key,
      width: width,
      height: height,
      borderRadius: borderRadius,
      baseColor: baseColor,
      highlightColor: highlightColor,
      enableShimmer: enableShimmer,
      duration: duration,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(color: baseColor ?? context.customColorScheme.greySwatch[200], shape: shapeBorder),
      child: child,
    );

    if (!enableShimmer) {
      return container;
    }

    return container.withShimmer(duration: duration, baseColor: baseColor, highlightColor: highlightColor);
  }
}

class ShimmerIcon extends StatelessWidget {
  const ShimmerIcon({
    super.key,
    required this.icon,
    this.size = 40,
    this.color,
    this.enableShimmer = true,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  final SvgGenImage icon;
  final double size;
  final Color? color;
  final bool enableShimmer;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final iconWidget = icon.svg(
      width: size,
      height: size,
      colorFilter: (color ?? context.customColorScheme.greySwatch[400])?.colorFilter,
    );

    if (!enableShimmer) {
      return iconWidget;
    }

    return iconWidget.withShimmer(duration: duration, baseColor: baseColor, highlightColor: highlightColor).center();
  }
}

// Backward compatibility
class ShimmerSvgIcon extends StatelessWidget {
  final SvgGenImage svg;
  final double? size;
  final double? placeholderSize;
  final bool enableShimmer;
  final Color? baseColor;
  final Color? highlightColor;
  final double? borderRadius;

  const ShimmerSvgIcon({
    super.key,
    required this.svg,
    this.size,
    this.placeholderSize,
    this.enableShimmer = true,
    this.baseColor,
    this.highlightColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = svg
        .svg(width: placeholderSize ?? size ?? 40, height: placeholderSize ?? size ?? 40, fit: BoxFit.cover)
        .center();

    if (!enableShimmer) {
      return Container(
        width: size ?? 40,
        decoration: BoxDecoration(
          borderRadius: borderRadius.borderRadius,
          color: context.customColorScheme.greySwatch.shade100,
        ),
        child: iconWidget,
      );
    }

    return Container(
      width: size ?? 40,
      color: context.customColorScheme.greySwatch.shade100,
      child: iconWidget.withShimmer(baseColor: baseColor, highlightColor: highlightColor),
    );
  }
}
