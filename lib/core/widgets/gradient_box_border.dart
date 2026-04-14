import 'package:flutter/material.dart';

class GradientBoxBorder extends BoxBorder {
  final Gradient gradient;
  final double width;
  final BorderRadius borderRadius;

  const GradientBoxBorder({required this.gradient, this.width = 2.0, this.borderRadius = BorderRadius.zero});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  ShapeBorder scale(double t) {
    return GradientBoxBorder(gradient: gradient, width: width * t, borderRadius: borderRadius * t);
  }

  @override
  BoxBorder? add(ShapeBorder other, {bool reversed = false}) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect).deflate(width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final paint = Paint()
      ..shader = gradient.createShader(rect, textDirection: textDirection)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    if (shape == BoxShape.circle) {
      final radius = rect.shortestSide / 2;
      canvas.drawCircle(rect.center, radius - width / 2, paint);
    } else {
      final radius = (borderRadius ?? this.borderRadius).toRRect(rect);
      canvas.drawRRect(radius.deflate(width / 2), paint);
    }
  }

  GradientBoxBorder copyWith({Gradient? gradient, double? width, BorderRadius? borderRadius}) {
    return GradientBoxBorder(
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  BorderSide get top => BorderSide(width: width, color: Colors.transparent);

  @override
  BorderSide get bottom => BorderSide(width: width, color: Colors.transparent);
}
