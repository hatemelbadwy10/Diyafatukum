import 'package:flutter/material.dart';

import '../config/extensions/all_extensions.dart';
import 'app_dialog.dart';

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
    return AppDialog(
      title: widget.title,
      subtitle: widget.subtitle,
      dismissible: false,
      icon: Icon(Icons.check_rounded, color: context.onPrimary, size: 28),
    );
  }
}
