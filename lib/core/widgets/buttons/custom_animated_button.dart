import 'package:flutter/material.dart';

import 'button_styles_enums.dart';
import 'custom_button.dart';

class CustomAnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Duration duration;
  final Duration delay;
  final double scaleBegin;
  final double scaleEnd;
  final Color? colorBegin;
  final Color? colorEnd;

  const CustomAnimatedButton({
    required this.label,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 1000),
    this.delay = const Duration(milliseconds: 200),
    this.scaleBegin = 1.0,
    this.scaleEnd = 1.05,
    this.colorBegin,
    this.colorEnd,
    super.key,
  });

  @override
  State<CustomAnimatedButton> createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _scaleAnimation = Tween<double>(
      begin: widget.scaleBegin,
      end: widget.scaleEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _colorAnimation = ColorTween(
      begin: widget.colorBegin,
      end: widget.colorEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startAnimationWithDelay();
  }

  void _startAnimationWithDelay() async {
    while (true) {
      if (!mounted) break;

      await _controller.forward();
      await _controller.reverse();
      await Future.delayed(widget.delay);
    }
  }

  void _stopAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: CustomButton(
            width: 100,
            borderRadius: 4,
            size: ButtonSize.small,
            label: widget.label,
            onPressed: () {
              _stopAnimation();
              _controller.reset();
              widget.onPressed();
            },
            backgroundColor: _colorAnimation.value,
          ),
        );
      },
    );
  }
}
