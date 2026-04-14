import 'package:flutter/material.dart';

/// A data class representing a child with animated flex properties
class AnimatedFlex {
  /// The widget to display
  final Widget child;

  /// Whether this child should be visible
  final bool isVisible;

  /// The flex value when visible (default: 1)
  final int flex;

  /// Custom margin for this child
  final EdgeInsetsGeometry? margin;

  /// Animation curve for this specific child (overrides global curve)
  final Curve? curve;

  /// Custom animation duration for this child (overrides global duration)
  final Duration? duration;

  /// Scale alignment for this child
  final Alignment? scaleAlignment;

  const AnimatedFlex({
    required this.child,
    required this.isVisible,
    this.flex = 1,
    this.margin,
    this.curve,
    this.duration,
    this.scaleAlignment,
  });
}

/// A reusable widget that animates flex values of children in a Row
class AnimatedFlexRow extends StatelessWidget {
  /// List of AnimatedFlex children
  final List<AnimatedFlex> children;

  /// Spacing between children
  final double spacing;

  /// Animation duration (can be overridden per child)
  final Duration duration;

  /// Animation curve (can be overridden per child)
  final Curve curve;

  /// Main axis alignment
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis size
  final MainAxisSize mainAxisSize;

  /// Text direction
  final TextDirection? textDirection;

  /// Vertical direction
  final VerticalDirection verticalDirection;

  /// Text baseline
  final TextBaseline? textBaseline;

  /// Whether to show scale animation
  final bool enableScaleAnimation;

  /// Whether to show opacity animation
  final bool enableOpacityAnimation;

  /// Default scale alignment for all children
  final Alignment scaleAlignment;

  const AnimatedFlexRow({
    super.key,
    required this.children,
    this.spacing = 0,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.enableScaleAnimation = false,
    this.enableOpacityAnimation = true,
    this.scaleAlignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: _buildAnimatedChildren(),
    );
  }

  List<Widget> _buildAnimatedChildren() {
    List<Widget> widgets = [];

    for (int i = 0; i < children.length; i++) {
      final animatedFlex = children[i];
      final childDuration = animatedFlex.duration ?? duration;
      final childCurve = animatedFlex.curve ?? curve;
      final childScaleAlignment = animatedFlex.scaleAlignment ?? scaleAlignment;

      // Add animated child
      widgets.add(
        TweenAnimationBuilder<double>(
          duration: childDuration,
          curve: childCurve,
          tween: Tween(begin: 0.0, end: animatedFlex.isVisible ? 1.0 : 0.0),
          builder: (context, animationValue, _) {
            // Skip rendering if completely hidden
            if (animationValue <= 0) {
              return const SizedBox.shrink();
            }

            Widget animatedChild = animatedFlex.child;

            // Apply opacity animation - clamp only opacity to stay within valid range
            if (enableOpacityAnimation) {
              animatedChild = Opacity(opacity: animationValue.clamp(0.0, 1.0), child: animatedChild);
            }

            // Apply scale animation - allow values outside 0-1 for bounce effect
            if (enableScaleAnimation) {
              animatedChild = Transform.scale(
                scale: animationValue.clamp(0.01, double.infinity), // Prevent zero scale
                alignment: childScaleAlignment,
                child: animatedChild,
              );
            }

            // Apply margin with animation
            if (animatedFlex.margin != null) {
              final margin = animatedFlex.margin!;
              final resolvedMargin = margin.resolve(textDirection);
              final clampedValue = animationValue.clamp(0.0, 1.0);
              final animatedMargin = EdgeInsets.only(
                left: resolvedMargin.left * clampedValue,
                right: resolvedMargin.right * clampedValue,
                top: resolvedMargin.top * clampedValue,
                bottom: resolvedMargin.bottom * clampedValue,
              );

              animatedChild = Container(margin: animatedMargin, child: animatedChild);
            }

            // Calculate animated flex value - ensure it's always positive
            final flexValue = animationValue.clamp(0.01, double.infinity);
            final animatedFlexValue = (animatedFlex.flex * flexValue * 100).round().clamp(1, 999999);

            return Expanded(
              flex: animatedFlexValue,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: i == children.length - 1 ? 0 : spacing),
                child: animatedChild,
              ),
            );
          },
        ),
      );
    }

    return widgets;
  }
}
