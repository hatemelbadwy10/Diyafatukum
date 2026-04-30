import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/shimmer_widget.dart';

class UserHomeSkeleton extends StatelessWidget {
  const UserHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth = (context.width - (AppSize.screenPadding * 2) - 16) / 2;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSize.screenPadding,
        16,
        AppSize.screenPadding,
        kBottomNavigationBarHeight + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerWidget.circular(radius: 28),
              12.gap,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerWidget.rectangular(width: double.infinity, height: 18, borderRadius: 8),
                    SizedBox(height: 8),
                    ShimmerWidget.rectangular(width: 180, height: 14, borderRadius: 8),
                  ],
                ),
              ),
              12.gap,
              const ShimmerWidget.circular(radius: 28),
            ],
          ),
          24.gap,
          const ShimmerWidget.rectangular(
            width: double.infinity,
            height: 56,
            borderRadius: AppSize.mainRadius,
          ),
          24.gap,
          const ShimmerWidget.rectangular(
            width: double.infinity,
            height: 270,
            borderRadius: 34,
          ),
          32.gap,
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: ShimmerWidget.rectangular(
              width: 220,
              height: 24,
              borderRadius: 8,
            ),
          ),
          8.gap,
          const ShimmerWidget.rectangular(width: double.infinity, height: 16, borderRadius: 8),
          24.gap,
          Wrap(
            spacing: 16,
            runSpacing: 20,
            children: List.generate(4, (_) {
              return SizedBox(
                width: cardWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    AspectRatio(
                      aspectRatio: 0.92,
                      child: ShimmerWidget.rectangular(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 26,
                      ),
                    ),
                    SizedBox(height: 12),
                    ShimmerWidget.rectangular(width: double.infinity, height: 16, borderRadius: 8),
                    SizedBox(height: 8),
                    ShimmerWidget.rectangular(width: 140, height: 16, borderRadius: 8),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
