import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../resources/enums/toast_type_enum.dart';
import 'buttons/custom_icon_button.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({super.key, required this.type, required this.text, this.onDismiss});

  final ToastType type;
  final String text;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: AppSize.screenPadding.edgeInsetsHorizontal,
        constraints: BoxConstraints(maxHeight: 100),
        decoration: BoxDecoration(
          color: type.backgroundColor,
          borderRadius: 16.borderRadius,
          border: Border.all(color: type.color),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textPainter = TextPainter(
              text: TextSpan(text: text, style: TextStylesManager.font.s13.regular.setColor(Colors.black)),
              maxLines: null,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(maxWidth: constraints.maxWidth - 100);

            final isMultiLine = textPainter.computeLineMetrics().length > 1;

            return Row(
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                // Container(
                //   margin: const EdgeInsets.all(12),
                //   padding: const EdgeInsets.all(6),
                //   decoration: ShapeDecoration(
                //     color: type.color,
                //     shape: ContinuousRectangleBorder(borderRadius: 20.borderRadius),
                //   ),
                //   child: type.icon.svg(width: 20),
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(text, style: TextStylesManager.font.s13.regular.setColor(Colors.black)),
                  ),
                ),
                if (onDismiss != null)
                  CustomIconButton(
                    foregroundColor: context.customColorScheme.greySwatch.shade500,
                    icon: Icons.cancel_outlined,
                    size: 20,
                    onPressed: onDismiss,
                  ).paddingAll(8),
              ],
            );
          },
        ),
      ),
    );
  }
}
