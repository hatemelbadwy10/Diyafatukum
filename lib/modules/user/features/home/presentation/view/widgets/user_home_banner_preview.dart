import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/widgets/custom_image.dart';

class UserHomeBannerPreview extends StatelessWidget {
  const UserHomeBannerPreview({
    super.key,
    required this.imageUrl,
    required this.currentIndex,
    required this.itemsCount,
  });

  final String imageUrl;
  final int currentIndex;
  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      decoration: BoxDecoration(
        borderRadius: 30.borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomImage.rounded(
            height: double.infinity,
            imageUrl: imageUrl,
            radius: 30,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: 30.borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.42),
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 12,
                height: 82,
                decoration: BoxDecoration(
                  color: context.scaffoldBackgroundColor.withValues(alpha: 0.16),
                  borderRadius: 100.borderRadius,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    itemsCount.clamp(2, 4),
                    (index) => AnimatedContainer(
                      duration: 350.milliseconds,
                      width: 4,
                      height: index == currentIndex % itemsCount.clamp(2, 4)
                          ? 28
                          : 18,
                      decoration: BoxDecoration(
                        color: context.scaffoldBackgroundColor.withValues(
                          alpha: index == currentIndex % itemsCount.clamp(2, 4)
                              ? 1
                              : 0.72,
                        ),
                        borderRadius: 100.borderRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
