import 'package:flutter/material.dart';

import '../config/extensions/all_extensions.dart';

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.onCompleted,
    this.duration = const Duration(seconds: 1),
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onCompleted;
  final Duration duration;

  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => this,
    );
  }

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  static const double _dialogWidth = 347;
  static const double _dialogHeight = 167;
  static const double _iconWrapperSize = 90;
  static const double _iconSize = 56;

  bool _isHandled = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, _complete);
  }

  void _complete() {
    if (_isHandled || !mounted) return;
    _isHandled = true;
    Navigator.of(context, rootNavigator: true).pop();
    widget.onCompleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.greySwatch.shade900.withValues(alpha: 0.12);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: _dialogWidth,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: _dialogWidth,
              height: _dialogHeight,
              margin: const EdgeInsets.only(top: 44),
              padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
              decoration: BoxDecoration(
                color: context.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 32,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: context.displayLarge.bold.s20.setHeight(1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.subtitle != null) ...[
                    12.gap,
                    Text(
                      widget.subtitle!,
                      textAlign: TextAlign.center,
                      style: context.bodyLarge.regular.s16
                          .setColor(context.greySwatch.shade700)
                          .setHeight(1.55),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: _iconWrapperSize,
              height: _iconWrapperSize,
              padding: 10.edgeInsetsAll,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.check_rounded,
                color: context.onPrimary,
                size: 28,
              ).circle(
                radius: _iconSize,
                backgroundColor: context.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
