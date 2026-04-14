import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/extensions/all_extensions.dart';
import '../resources/resources.dart';
import 'buttons/custom_buttons.dart';

class DialogAction {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;
  final bool isCancel;
  final bool isDefault;
  final bool isDestructive;
  final bool isLoading;
  final bool autoCloseOnAction;

  const DialogAction({
    required this.label,
    this.color,
    this.onPressed,
    this.icon,
    this.isCancel = false,
    this.isDefault = false,
    this.isDestructive = false,
    this.isLoading = false,
    this.autoCloseOnAction = true,
  });

  // Enhanced factory constructors
  factory DialogAction.cancel({String? label, VoidCallback? onPressed, bool isLoading = false, IconData? icon}) {
    return DialogAction(
      label: label ?? LocaleKeys.actions_cancel.tr(),
      onPressed: onPressed,
      icon: icon ?? Icons.close,
      isCancel: true,
      isDefault: false,
      isLoading: isLoading,
      autoCloseOnAction: true,
    );
  }

  factory DialogAction.confirm({
    String? label,
    VoidCallback? onPressed,
    Color? color,
    bool isLoading = false,
    IconData? icon,
  }) {
    return DialogAction(
      label: label ?? LocaleKeys.actions_confirm.tr(),
      onPressed: onPressed,
      color: color,
      icon: icon ?? Icons.check,
      isDefault: true,
      isDestructive: false,
      isLoading: isLoading,
      autoCloseOnAction: true,
    );
  }

  factory DialogAction.destructive({
    String? label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool autoCloseOnAction = false,
  }) {
    return DialogAction(
      label: label ?? LocaleKeys.actions_confirm.tr(),
      onPressed: onPressed,
      icon: icon ?? Icons.delete_outline,
      isDestructive: true,
      isDefault: true,
      isLoading: isLoading,
      autoCloseOnAction: autoCloseOnAction,
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.title,
    this.subtitle,
    this.content,
    this.icon,
    this.actions = const [],
    this.dismissible = true,
    this.showCloseButton = false,
    this.maxWidth,
    this.alignment = Alignment.center,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
    this.radius,
    this.elevation,
    this.shadowColor,
    this.barrierColor,
    this.animationDuration,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.isLoading = false,
    this.autoCloseOnAction = false,
  });

  final String? title;
  final String? subtitle;
  final Widget? content;
  final Widget? icon;
  final List<DialogAction> actions;
  final bool dismissible;
  final bool showCloseButton;
  final double? maxWidth;
  final Alignment alignment;
  final EdgeInsets? padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? backgroundColor;
  final double? radius;
  final double? elevation;
  final Color? shadowColor;
  final Color? barrierColor;
  final Duration? animationDuration;

  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool isLoading;
  final bool autoCloseOnAction;

  // Computed actions - prioritize manual actions over quick params
  List<DialogAction> get _computedActions {
    if (actions.isNotEmpty) return actions;

    final List<DialogAction> quickActions = [];

    // Always add cancel action by default if no manual actions are provided
    if (cancelLabel != null || onCancel != null || (confirmLabel != null || onConfirm != null)) {
      quickActions.add(DialogAction.cancel(label: cancelLabel, onPressed: onCancel ?? () {}));
    }

    if (confirmLabel != null || onConfirm != null) {
      if (isDestructive) {
        quickActions.add(DialogAction.destructive(label: confirmLabel, onPressed: onConfirm, isLoading: isLoading));
      } else {
        quickActions.add(DialogAction.confirm(label: confirmLabel, onPressed: onConfirm, isLoading: isLoading));
      }
    }

    return quickActions;
  }

  factory CustomDialog.destructive({
    String? title,
    String? subtitle,
    Widget? content,
    String? confirmLabel,
    String? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isLoading = false,
    bool autoCloseOnAction = false,
  }) {
    return CustomDialog(
      title: title,
      subtitle: subtitle,
      content: content,
      autoCloseOnAction: autoCloseOnAction,
      actions: [
        DialogAction.destructive(
          label: confirmLabel,
          onPressed: onConfirm,
          isLoading: isLoading,
          autoCloseOnAction: autoCloseOnAction,
        ),
        DialogAction.cancel(label: cancelLabel, onPressed: onCancel),
      ],
    );
  }

  Future<T?> show<T>(BuildContext context, {bool dismissible = true}) {
    return showDialog<T>(context: context, barrierDismissible: dismissible, builder: (_) => center());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: elevation,
      shadowColor: shadowColor,
      backgroundColor: backgroundColor ?? context.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 12)),
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 400),
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            if (showCloseButton) ...[
              Row(
                children: [
                  const Spacer(),
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close), iconSize: 20),
                ],
              ),
            ],

            // Icon
            if (icon != null) icon!,

            // Title
            if (title != null) ...[
              Text(title!, textAlign: TextAlign.center, style: titleStyle ?? _getTitleStyle(context)),
            ],

            // Subtitle
            if (subtitle != null) ...[
              Text(subtitle!, textAlign: TextAlign.center, style: subtitleStyle ?? _getSubtitleStyle(context)),
            ],

            // Content
            if (content != null) ...[content!],

            // Actions
            if (_computedActions.isNotEmpty) ...[8.gap, _buildActions(context)],
          ],
        ),
      ),
    );
  }

  TextStyle _getTitleStyle(BuildContext context) {
    return context.titleLarge.medium.s20;
  }

  TextStyle _getSubtitleStyle(BuildContext context) {
    return context.bodyLarge.regular.s16;
  }

  Widget _buildActions(BuildContext context) {
    final actionsToRender = _computedActions;
    if (actionsToRender.isEmpty) return const SizedBox.shrink();

    // Fixed platform detection: Android uses Material, iOS uses Cupertino
    if (Platform.isIOS || Platform.isMacOS) {
      return _buildCupertinoActions(context, actionsToRender);
    } else {
      // Android and other platforms use Material Design
      return _buildMaterialActions(context, actionsToRender);
    }
  }

  Widget _buildMaterialActions(BuildContext context, List<DialogAction> actionsToRender) {
    // Material Design: Primary action on the right
    final sortedActions = [...actionsToRender];
    sortedActions.sort((a, b) {
      if (a.isDefault && !b.isDefault) return 1;
      if (!a.isDefault && b.isDefault) return -1;
      return 0;
    });

    if (actionsToRender.length == 1) {
      return SizedBox(width: double.infinity, child: _buildActionButton(context, actionsToRender.first));
    }

    if (actionsToRender.length == 2) {
      return Row(
        spacing: 16,
        children: [
          _buildActionButton(context, sortedActions.first, isSecondary: true).expand(),
          _buildActionButton(context, sortedActions.last).expand(),
        ],
      );
    }

    // More than 2 actions: Stack vertically
    return Column(
      spacing: 12,
      children:
          sortedActions.map((action) {
            return SizedBox(width: double.infinity, child: _buildActionButton(context, action));
          }).toList(),
    );
  }

  Widget _buildCupertinoActions(BuildContext context, List<DialogAction> actionsToRender) {
    // Cupertino: Destructive action on the left, default on the right
    final destructiveActions = actionsToRender.where((a) => a.isDestructive).toList();
    final defaultActions = actionsToRender.where((a) => a.isDefault && !a.isDestructive).toList();
    final otherActions = actionsToRender.where((a) => !a.isDefault && !a.isDestructive).toList();

    final orderedActions = [...destructiveActions, ...otherActions, ...defaultActions];

    if (actionsToRender.length == 1) {
      return SizedBox(width: double.infinity, child: _buildActionButton(context, actionsToRender.first));
    }

    if (actionsToRender.length == 2) {
      return Row(
        spacing: 16,
        children: [
          _buildActionButton(context, orderedActions.first, isSecondary: !orderedActions.first.isDefault).expand(),
          _buildActionButton(context, orderedActions.last).expand(),
        ],
      );
    }

    return Column(
      spacing: 12,
      children:
          orderedActions.map((action) {
            return SizedBox(width: double.infinity, child: _buildActionButton(context, action));
          }).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, DialogAction action, {bool isSecondary = false}) {
    onPressed() {
      if (action.autoCloseOnAction && !action.isLoading) {
        context.pop();
      }
      action.onPressed?.call();
    }

    if (action.isDestructive) {
      return CustomButton.destructive(label: action.label, onPressed: onPressed, isLoading: action.isLoading);
    }

    if (isSecondary || (!action.isDefault && !action.isDestructive)) {
      return CustomButton.outlined(label: action.label, onPressed: onPressed, isLoading: action.isLoading);
    }

    return CustomButton(
      label: action.label,
      onPressed: onPressed,
      isLoading: action.isLoading,
      backgroundColor: action.color,
      icon: action.icon,
    );
  }
}
