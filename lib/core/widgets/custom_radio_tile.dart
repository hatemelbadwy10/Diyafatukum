import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';

class CustomRadioTile<T> extends StatefulWidget {
  const CustomRadioTile({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
    this.onChanged,
    required this.value,
    required this.groupValue,
    this.isDisabled = false,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 4,
    this.radioPosition = RadioPosition.leading,
    this.contentSpacing = 8,
    this.iconSize,
    this.titleStyle,
    this.subtitleStyle,
    this.selectedColor,
    this.unselectedColor,
    this.disabledColor,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.borderWidth = 1,
    this.radioSize = 10,
    this.selectedRadioSize = 4,
    this.dense = false,
    this.visualDensity,
    this.allowDeselect = true,
  });

  final T value;
  final T? groupValue;
  final String? title;
  final String? subtitle;
  final Widget? icon;
  final Widget? leading;
  final Widget? trailing;
  final void Function(T?)? onChanged;
  final bool isDisabled;

  // Styling properties
  final EdgeInsets padding;
  final double borderRadius;
  final RadioPosition radioPosition;
  final double contentSpacing;
  final double? iconSize;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? disabledColor;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final double borderWidth;
  final double radioSize;
  final double selectedRadioSize;
  final bool dense;
  final VisualDensity? visualDensity;
  final bool allowDeselect;

  @override
  State<CustomRadioTile<T>> createState() => _CustomRadioTileState<T>();
}

enum RadioPosition { leading, trailing }

class _CustomRadioTileState<T> extends State<CustomRadioTile<T>> {
  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.groupValue == widget.value;
    final effectiveVisualDensity = widget.visualDensity ?? Theme.of(context).visualDensity;

    return Padding(
          padding: widget.padding,
          child: Row(mainAxisSize: MainAxisSize.min, children: _buildContent(isSelected, effectiveVisualDensity)),
        )
        .onTap(widget.isDisabled ? null : _handleTap, borderRadius: widget.borderRadius.borderRadius)
        .setContainerToView(
          color: _getBackgroundColor(isSelected),
          borderColor: _getBorderColor(isSelected),
          radius: widget.borderRadius,
        );
  }

  List<Widget> _buildContent(bool isSelected, VisualDensity visualDensity) {
    final List<Widget> content = [];
    final double spacing = widget.dense ? widget.contentSpacing / 2 : widget.contentSpacing;

    // Leading content
    if (widget.radioPosition == RadioPosition.leading) {
      content.add(_buildRadioButton(isSelected));
      if (_hasMainContent()) content.add(SizedBox(width: spacing));
    }

    // Custom leading widget
    if (widget.leading != null) {
      content.add(widget.leading!);
      content.add(SizedBox(width: spacing / 2));
    }

    // Icon
    if (widget.icon != null) {
      content.add(_buildIcon());
      content.add(SizedBox(width: spacing / 2));
    }

    // Text content
    if (widget.title != null || widget.subtitle != null) {
      content.add(Expanded(child: _buildTextContent()));
    }

    // Trailing content
    if (widget.trailing != null) {
      content.add(const Spacer());
      content.add(widget.trailing!);
    }

    if (widget.radioPosition == RadioPosition.trailing) {
      if (_hasMainContent()) content.add(SizedBox(width: spacing));
      content.add(_buildRadioButton(isSelected));
    }

    return content;
  }

  Widget _buildRadioButton(bool isSelected) {
    return CircleAvatar(
      radius: widget.radioSize,
      backgroundColor: _getRadioColor(isSelected),
      child: CircleAvatar(
        radius: isSelected ? widget.selectedRadioSize : widget.radioSize - 1,
        backgroundColor: _getBackgroundColor(isSelected),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.iconSize != null) {
      return SizedBox(width: widget.iconSize, height: widget.iconSize, child: widget.icon!);
    }
    return widget.icon!;
  }

  Widget _buildTextContent() {
    if (widget.subtitle != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null) Text(widget.title!, style: _getTitleStyle()),
          if (widget.title != null && widget.subtitle != null) SizedBox(height: widget.dense ? 2 : 4),
          Text(widget.subtitle!, style: _getSubtitleStyle()),
        ],
      );
    } else if (widget.title != null) {
      return Text(widget.title!, style: _getTitleStyle());
    }
    return const SizedBox.shrink();
  }

  void _handleTap() {
    if (widget.allowDeselect && widget.groupValue == widget.value) {
      widget.onChanged?.call(null);
    } else {
      widget.onChanged?.call(widget.value);
    }
  }

  bool _hasMainContent() {
    return widget.title != null ||
        widget.subtitle != null ||
        widget.icon != null ||
        widget.leading != null ||
        widget.trailing != null;
  }

  // Color getters
  Color _getRadioColor(bool isSelected) {
    if (widget.isDisabled) {
      return widget.disabledColor ?? context.disabledButtonColor;
    }
    return isSelected
        ? (widget.selectedColor ?? context.primaryColor)
        : (widget.unselectedColor ?? context.inputFieldBorderColor);
  }

  Color _getBackgroundColor(bool isSelected) {
    if (isSelected && widget.selectedBackgroundColor != null) {
      return widget.selectedBackgroundColor!;
    }
    return widget.backgroundColor ?? context.scaffoldBackgroundColor;
  }

  Color _getBorderColor(bool isSelected) {
    if (widget.isDisabled) {
      return widget.disabledColor ?? context.disabledButtonColor;
    }
    if (isSelected && widget.selectedBorderColor != null) {
      return widget.selectedBorderColor!;
    }
    return widget.borderColor ?? Colors.transparent;
  }

  // Style getters
  TextStyle _getTitleStyle() {
    if (widget.titleStyle != null) return widget.titleStyle!;

    final baseStyle = context.titleSmall.s14.regular;
    if (widget.isDisabled) {
      return baseStyle.copyWith(color: widget.disabledColor ?? context.disabledButtonColor);
    }
    return baseStyle;
  }

  TextStyle _getSubtitleStyle() {
    if (widget.subtitleStyle != null) return widget.subtitleStyle!;

    final baseStyle = context.bodySmall.s12.regular;
    if (widget.isDisabled) {
      return baseStyle.copyWith(color: widget.disabledColor ?? context.disabledButtonColor);
    }
    return baseStyle;
  }
}
