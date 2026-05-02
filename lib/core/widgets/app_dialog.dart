import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../config/extensions/all_extensions.dart';
import '../resources/resources.dart';
import 'buttons/custom_button.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.content,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.dismissible = true,
    this.autoCloseOnConfirm = true,
    this.autoCloseOnCancel = true,
    this.confirmResult,
    this.cancelResult,
    this.confirmDestructive = false,
    this.iconBackgroundColor,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? content;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool dismissible;
  final bool autoCloseOnConfirm;
  final bool autoCloseOnCancel;
  final Object? confirmResult;
  final Object? cancelResult;
  final bool confirmDestructive;
  final Color? iconBackgroundColor;

  static const double _dialogWidth = 347;
  static const double _iconWrapperSize = 90;
  static const double _iconSize = 56;

  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      useRootNavigator: true,
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.greySwatch.shade900.withValues(alpha: 0.12);
    final hasActions =
        confirmLabel != null ||
        cancelLabel != null ||
        onConfirm != null ||
        onCancel != null;

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.displayLarge.bold.s20.setHeight(1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    12.gap,
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: context.bodyLarge.regular.s16
                          .setColor(context.greySwatch.shade700)
                          .setHeight(1.55),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (content != null) ...[16.gap, content!],
                  if (hasActions) ...[24.gap, _buildActions(context)],
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
              child:
                  (icon ??
                          Icon(
                            Icons.check_rounded,
                            color: context.onPrimary,
                            size: 28,
                          ))
                      .circle(
                        radius: _iconSize,
                        backgroundColor:
                            iconBackgroundColor ?? context.primaryColor,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final hasCancel = cancelLabel != null || onCancel != null;
    final hasConfirm = confirmLabel != null || onConfirm != null;

    if (hasCancel && hasConfirm) {
      return Row(
        children: [
          CustomButton.outlined(
            label: cancelLabel ?? LocaleKeys.actions_cancel.tr(),
            onPressed: () => _handleAction(
              context,
              result: cancelResult,
              shouldClose: autoCloseOnCancel,
              callback: onCancel,
            ),
          ).expand(),
          12.gap,
          (confirmDestructive
                  ? CustomButton.destructive(
                      label: confirmLabel ?? LocaleKeys.actions_confirm.tr(),
                      onPressed: () => _handleAction(
                        context,
                        result: confirmResult,
                        shouldClose: autoCloseOnConfirm,
                        callback: onConfirm,
                      ),
                    )
                  : CustomButton(
                      label: confirmLabel ?? LocaleKeys.actions_confirm.tr(),
                      onPressed: () => _handleAction(
                        context,
                        result: confirmResult,
                        shouldClose: autoCloseOnConfirm,
                        callback: onConfirm,
                      ),
                    ))
              .expand(),
        ],
      );
    }

    if (hasConfirm) {
      return confirmDestructive
          ? CustomButton.destructive(
              label: confirmLabel ?? LocaleKeys.actions_confirm.tr(),
              onPressed: () => _handleAction(
                context,
                result: confirmResult,
                shouldClose: autoCloseOnConfirm,
                callback: onConfirm,
              ),
            )
          : CustomButton(
              label: confirmLabel ?? LocaleKeys.actions_confirm.tr(),
              onPressed: () => _handleAction(
                context,
                result: confirmResult,
                shouldClose: autoCloseOnConfirm,
                callback: onConfirm,
              ),
            );
    }

    return CustomButton.outlined(
      label: cancelLabel ?? LocaleKeys.actions_cancel.tr(),
      onPressed: () => _handleAction(
        context,
        result: cancelResult,
        shouldClose: autoCloseOnCancel,
        callback: onCancel,
      ),
    );
  }

  void _handleAction(
    BuildContext context, {
    required Object? result,
    required bool shouldClose,
    VoidCallback? callback,
  }) {
    if (shouldClose) {
      Navigator.of(context, rootNavigator: true).pop(result);
    }
    callback?.call();
  }
}
