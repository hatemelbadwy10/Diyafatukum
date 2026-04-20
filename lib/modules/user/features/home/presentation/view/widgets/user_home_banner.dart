import 'package:easy_localization/easy_localization.dart';
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
  late final List<String> _bannerImages = _resolveBannerImages();
  int _currentIndex = 0;

  List<String> _resolveBannerImages() {
    final images = widget.data.services
        .map((service) => service.imagePath)
        .where((path) => path.isNotEmpty)
        .toSet()
        .toList();

    if (images.isEmpty) {
      return const [
        'assets/images/home_banner.png',
        'assets/images/welcome_screen.png',
      ];
    }

    if (images.length == 1) {
      images.add(images.first == 'assets/images/home_banner.png' ? 'assets/images/welcome_screen.png' : 'assets/images/home_banner.png');
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    final nextIndex = (_currentIndex + 1) % _bannerImages.length;
    return SizedBox(
      height: 270,
      child: Stack(
        children: [
          PositionedDirectional(
            start: 0,
            top: 18,
            bottom: 18,
            child: UserHomeBannerPreview(
              imagePath: _bannerImages[nextIndex],
              currentIndex: _currentIndex,
              itemsCount: _bannerImages.length,
            ),
          ),
          PositionedDirectional(
            start: 40,
            end: 0,
            top: 0,
            bottom: 0,
            child: CustomSlider(
              height: 270,
              itemCount: _bannerImages.length,
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
                return UserHomeBannerSlide(
                  imagePath: _bannerImages[itemIndex],
                  title: widget.data.bannerTitleKey.tr(),
                  actionLabel: widget.data.bannerActionKey.tr(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
