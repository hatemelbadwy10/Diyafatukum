import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../config/extensions/all_extensions.dart';

class AnimatedSlideText extends StatelessWidget {
  const AnimatedSlideText({
    super.key,
    required this.isVisible,
     this.text,
    this.textStyle,
    this.slideFromStart = true,
    this.duration = const Duration(milliseconds: 300),
    this.slideCurve = Curves.easeInOutExpo,
    this.sizeCurve = Curves.easeOutCubic,
    this.paddingTop = 4,
    this.paddingStart = 4,
    this.showFadeAnimation = true,
    this.fadeDelay = Duration.zero,
    this.alignment = CrossAxisAlignment.start,
  });

  /// Whether the text should be visible
  final bool isVisible;

  /// The text to display
  final String? text;

  /// Text style, if null will use context.textTheme.bodyMedium
  final TextStyle? textStyle;

  /// Whether to slide from start (true) or end (false)
  final bool slideFromStart;

  /// Duration for both slide and size animations
  final Duration duration;

  /// Curve for the slide animation
  final Curve slideCurve;

  /// Curve for the size animation
  final Curve sizeCurve;

  /// Top padding for the text
  final double paddingTop;

  /// Start padding for the text
  final double paddingStart;

  /// Whether to show fade animation on the text
  final bool showFadeAnimation;

  /// Delay for the fade animation
  final Duration fadeDelay;

  /// Cross axis alignment for the text container
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration,
      curve: sizeCurve,
      child: AnimatedSlide(
        offset: context.getSlideOffset(isVisible: isVisible, slideFromStart: slideFromStart),
        duration: duration,
        curve: slideCurve,
        child: isVisible && text != null ? _buildText(context) : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    Widget textWidget = Text(
      text!,
      style: textStyle ?? context.textTheme.bodyMedium,
    ).paddingTop(paddingTop).paddingStart(paddingStart);

    if (showFadeAnimation) {
      textWidget = textWidget.animate().fade(duration: duration, delay: fadeDelay);
    }

    return textWidget;
  }
}
