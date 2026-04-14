import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import 'buttons/custom_buttons.dart';

enum PaginationArrowType { next, back }

class CustomArrow extends StatefulWidget {
  const CustomArrow({super.key, this.onTap, required this.type, this.enabled = true});

  final bool enabled;
  final PaginationArrowType type;
  final void Function()? onTap;

  const CustomArrow.next({super.key, this.onTap, this.enabled = true}) : type = PaginationArrowType.next;

  const CustomArrow.back({super.key, this.onTap, this.enabled = true}) : type = PaginationArrowType.back;

  @override
  State<CustomArrow> createState() => _CustomArrowState();
}

class _CustomArrowState extends State<CustomArrow> {
  @override
  void didUpdateWidget(covariant CustomArrow oldWidget) {
    if (oldWidget.enabled != widget.enabled) {}
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomIconButton.svg(
      size: 24,
      borderRadius: 40,
      padding: 12.edgeInsetsAll,
      matchTextDirection: true,
      foregroundColor: context.onPrimary,
      backgroundColor: context.primaryColor,
      onPressed: widget.enabled ? widget.onTap : null,
      svg: widget.type == PaginationArrowType.next ? Assets.icons.arrowRightAlt : Assets.icons.arrowLeftAlt,
    );
  }
}
