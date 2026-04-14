import 'package:flutter/material.dart';

class CustomAnimatedContainer extends StatefulWidget {
  final Decoration? decoration;
  final Duration? duration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final Curve? curve;
  final bool showChild;
  final Color? color;
  final double? radius;
  final List<BoxShadow>? shadows;

  const CustomAnimatedContainer({
    super.key,
    this.decoration,
    this.duration,
    this.padding,
    this.margin,
    this.curve,
    required this.child,
    this.showChild = true,
    this.color,
    this.radius,
    this.shadows,
  });

  @override
  State<CustomAnimatedContainer> createState() => _CustomAnimatedContainerState();
}

class _CustomAnimatedContainerState extends State<CustomAnimatedContainer> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        padding: widget.padding ?? EdgeInsets.zero,
        decoration:
            widget.decoration ??
            BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.radius ?? 0),
              boxShadow: widget.shadows,
            ),
        child: AnimatedSize(
          alignment: AlignmentDirectional.center,
          duration: widget.duration ?? const Duration(milliseconds: 300),
          curve: widget.curve ?? Curves.easeInOutBack,
          child: widget.showChild ? widget.child : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
