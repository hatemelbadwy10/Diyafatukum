import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';

class UserHomeBannerSlide extends StatelessWidget {
  const UserHomeBannerSlide({
    super.key,
    required this.imagePath,
    required this.title,
    required this.actionLabel,
  });

  final String imagePath;
  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 34.borderRadius,
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: 24.edgeInsetsAll,
        decoration: BoxDecoration(
          borderRadius: 34.borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.12),
              Colors.black.withValues(alpha: 0.55),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.images.logo.image(height: 62, fit: BoxFit.contain),
            const Spacer(),
            Text(
              title,
              style: context.displayLarge.bold.s28
                  .setColor(context.onPrimary)
                  .setHeight(1.35),
            ),
            18.gap,
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: CustomButton.stadium(
                width: 142,
                height: 50,
                label: actionLabel,
                backgroundColor: context.scaffoldBackgroundColor,
                fontColor: context.titleMedium.color,
                borderRadius: 100,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
