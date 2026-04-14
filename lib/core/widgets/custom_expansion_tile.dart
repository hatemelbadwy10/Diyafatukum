import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../resources/resources.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    super.key,
    this.titleText,
    this.title,
    this.content,
    this.enableBorder = false,
    this.titlePadding,
    this.contentPadding,
    this.children,
    this.trailing,
    this.titleStyle,
    this.initiallyExpanded = false,
    this.expandedAlignment,
    this.reverse = false,
    this.color,
    this.spacing = 0,
    this.expandedTrailing,
    this.collapsedTrailing,
  });

  final bool reverse;
  final Widget? title;
  final String? titleText;
  final String? content;
  final bool enableBorder;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final List<Widget>? children;
  final Widget? trailing;
  final TextStyle? titleStyle;
  final bool initiallyExpanded;
  final Alignment? expandedAlignment;
  final Color? color;
  final double spacing;

  final Widget? expandedTrailing;
  final Widget? collapsedTrailing;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> with TickerProviderStateMixin {
  late final ValueNotifier<bool> _isExpanded;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _isExpanded = ValueNotifier(widget.initiallyExpanded);
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    if (widget.initiallyExpanded) {
      _animationController.value = 1.0;
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _isExpanded.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded.value = !_isExpanded.value;
      if (_isExpanded.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Always use custom implementation for full control
    return _buildCustomExpansionTile();
  }

  Widget _buildCustomExpansionTile() {
    final contentWidget = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _animation,
          child: Material(
            color: widget.color ?? Colors.transparent,
            child: InkWell(
              onTap: _toggleExpansion,
              child: Container(
                decoration: widget.enableBorder
                    ? BoxDecoration(
                        border: Border.all(color: context.inputFieldBorderColor),
                        borderRadius: AppSize.mainRadius.borderRadius,
                      )
                    : null,
                child: Padding(
                  padding: widget.contentPadding ?? const EdgeInsets.all(12),
                  child: Column(
                    spacing: widget.spacing,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.children ?? [Text(widget.content ?? '', style: context.bodyMedium.s14)],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    final titleWidget = Material(
      color: widget.color ?? Colors.transparent,
      shape: _buildShapeBorder(),
      child: InkWell(
        onTap: _toggleExpansion,
        customBorder: _buildShapeBorder(),
        child: Container(
          padding: widget.titlePadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child:
                    widget.title ??
                    Text(widget.titleText ?? '', style: widget.titleStyle ?? context.titleLarge.s14.regular),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.trailing != null) ...[widget.trailing!, 8.gap],
                  ValueListenableBuilder(
                    valueListenable: _isExpanded,
                    builder: (context, value, child) => _getTrailing(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Return different layouts based on reverse
    if (widget.reverse) {
      return Column(mainAxisSize: MainAxisSize.min, children: [contentWidget, titleWidget]);
    } else {
      return Column(mainAxisSize: MainAxisSize.min, children: [titleWidget, contentWidget]);
    }
  }

  ShapeBorder? _buildShapeBorder() {
    if (!widget.enableBorder) return null;
    return RoundedRectangleBorder(
      side: BorderSide(color: context.inputFieldBorderColor),
      borderRadius: AppSize.mainRadius.borderRadius,
    );
  }

  Widget _buildDropdownArrow() {
    final turns = _isExpanded.value ? 0.5 : 0.0;
    final turnsReverse = _isExpanded.value ? 0.0 : 0.5;
    return AnimatedRotation(
      turns: widget.reverse ? turnsReverse : turns,
      duration: 200.milliseconds,
      child: Assets.icons.arrowDown.svg(height: 16, colorFilter: context.iconColor.colorFilter),
    );
  }

  Widget _getTrailing() {
    if (widget.expandedTrailing != null && widget.collapsedTrailing != null) {
      return _buildTrailingAnimation();
    } else if (widget.expandedTrailing != null) {
      return _isExpanded.value ? widget.expandedTrailing! : const SizedBox.shrink();
    } else if (widget.collapsedTrailing != null) {
      return !_isExpanded.value ? widget.collapsedTrailing! : const SizedBox.shrink();
    } else {
      return _buildDropdownArrow();
    }
  }

  // trailing animation switching
  Widget _buildTrailingAnimation() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isExpanded.value
          ? KeyedSubtree(key: const ValueKey('expanded'), child: widget.expandedTrailing ?? _buildDropdownArrow())
          : KeyedSubtree(key: const ValueKey('collapsed'), child: widget.collapsedTrailing ?? _buildDropdownArrow()),
    );
  }
}
