import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_slider.dart';
import '../../../data/model/user_home_model.dart';
import 'user_home_banner_preview.dart';
import 'user_home_banner_slide.dart';

class UserHomeBanner extends StatefulWidget {
  const UserHomeBanner({super.key, required this.data});

  final UserHomeModel data;

  @override
  State<UserHomeBanner> createState() => _UserHomeBannerState();
}

class _UserHomeBannerState extends State<UserHomeBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.data.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final banners = widget.data.banners;
    final nextIndex = (_currentIndex + 1) % banners.length;
    return SizedBox(
      height: 270,
      child: Stack(
        children: [
          PositionedDirectional(
            start: 0,
            top: 18,
            bottom: 18,
            child: UserHomeBannerPreview(
              imageUrl: banners[nextIndex].imageUrl,
              currentIndex: _currentIndex,
              itemsCount: banners.length,
            ),
          ),
          PositionedDirectional(
            start: 40,
            end: 0,
            top: 0,
            bottom: 0,
            child: CustomSlider(
              height: 270,
              itemCount: banners.length,
              autoPlay: true,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(milliseconds: 2600),
              autoPlayAnimationDuration: const Duration(milliseconds: 1600),
              autoPlayCurve: Curves.easeInOutCubicEmphasized,
              onPageChanged: (index, _) {
                if (!mounted || _currentIndex == index) return;
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, itemIndex, _) {
                final banner = banners[itemIndex];
                return UserHomeBannerSlide(
                  banner: banner,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
