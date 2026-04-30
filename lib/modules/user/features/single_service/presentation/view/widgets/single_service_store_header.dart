import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_image.dart';
import '../../../data/model/single_service_store_model.dart';

class SingleServiceStoreHeader extends StatelessWidget {
  const SingleServiceStoreHeader({super.key, required this.store});

  final SingleServiceStoreDetailsModel store;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: 1.08,
          child: ClipRRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomImage(height: double.infinity, imageUrl: store.logo),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.08),
                        Colors.black.withValues(alpha: 0.58),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            16.gap,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  store.specializationName,
                  style: context.bodySmall.regular.s14.setColor(
                    context.scaffoldBackgroundColor.withValues(alpha: 0.86),
                  ),
                ),
                4.gap,
                Text(
                  store.name,
                  style: context.titleLarge.bold.s28.setColor(
                    context.scaffoldBackgroundColor,
                  ),
                  textAlign: TextAlign.start,
                ),
                8.gap,
                Row(
                  children: [
                    Assets.icons.locationPinDisabled.path.toSvg(
                      width: 16,
                      height: 16,
                      color: context.scaffoldBackgroundColor,
                    ),
                    6.gap,
                    Text(
                      store.address,
                      style: context.bodyMedium.regular.s16.setColor(
                        context.scaffoldBackgroundColor,
                      ),
                    ).flexible(),
                  ],
                ),
              ],
            ).expand(),
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF25D366),
                shape: BoxShape.circle,
              ),
              child: Assets.icons.whatsapp
                  .svg(
                    width: 24,
                    height: 24,
                    colorFilter: Colors.white.colorFilter,
                  )
                  .center(),
            ).onTap(() => store.whatsapp.launchWhatsApp()),
          ],
        ).paddingOnly(
          bottom: 28,
          left: AppSize.screenPadding,
          right: AppSize.screenPadding,
        ),
      ],
    );
  }
}
