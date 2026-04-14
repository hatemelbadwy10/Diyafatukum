import 'package:flutter/material.dart';

class CustomImageClipper extends CustomClipper<Path> {
  final bool isRTL;

  const CustomImageClipper({required this.isRTL});

  @override
  Path getClip(Size size) {
    Path path = Path();
    double width = size.width;
    double height = size.height;

    if (!isRTL) {
      // RTL version (mirrored horizontally)
      path.moveTo(width, 0);
      path.lineTo(width, height); // Move down to A (mirrored)

      path.arcToPoint(
        Offset(width - 94, height - 80), // B (mirrored)
        radius: const Radius.circular(100),
        clockwise: false, // Outer curve reversed
      );

      path.lineTo(94, height - 80); // C (mirrored)

      path.arcToPoint(
        Offset(0, height - 160), // D (mirrored)
        radius: const Radius.circular(100),
        clockwise: true, // Inner curve reversed
      );

      path.lineTo(0, 0);
    } else {
      // LTR version (original)
      path.lineTo(0, height); // Move down to A

      path.arcToPoint(
        Offset(94, height - 80), // B
        radius: const Radius.circular(100),
        clockwise: true, // Outer curve
      );

      path.lineTo(width - 94, height - 80); // C

      path.arcToPoint(
        Offset(width, height - 160), // D
        radius: const Radius.circular(100),
        clockwise: false, // Inner curve
      );

      path.lineTo(width, 0);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
