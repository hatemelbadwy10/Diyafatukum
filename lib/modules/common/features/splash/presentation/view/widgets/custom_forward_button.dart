import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';

class CustomForwardButton extends StatefulWidget {
  const CustomForwardButton({super.key, required this.onTap});
  final void Function() onTap;

  @override
  State<CustomForwardButton> createState() => _CustomForwardButtonState();
}

class _CustomForwardButtonState extends State<CustomForwardButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _firstArrowAnimation;
  late Animation<double> _secondArrowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);

    _firstArrowAnimation = Tween<double>(
      begin: -3,
      end: 3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _secondArrowAnimation = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );
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
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 12,
              child: Transform.translate(
                offset: Offset(_firstArrowAnimation.value, 0),
                child: Assets.icons.iconamoonArrowUp2Light
                    .svg(width: 16, height: 16)
                    .opacity(opacity: context.isRTL ? 0.5 : 1)
                    .flipHorizontal(enable: !context.isRTL),
              ),
            ),
            Positioned(
              right: 20,
              child: Transform.translate(
                offset: Offset(_secondArrowAnimation.value, 0),
                child: Assets.icons.stashArrowUpDuotone
                    .svg(width: 16, height: 16)
                    .opacity(opacity: context.isRTL ? 1 : 0.5)
                    .flipHorizontal(enable: !context.isRTL),
              ),
            ),
          ],
        )
            .setContainerToView(height: 32, width: 54, radius: 100, color: context.primaryColor)
            .onTap(widget.onTap, borderRadius: 12.borderRadius);
      },
    );
  }
}
