import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/widgets/custom_image.dart';
import '../../../data/model/user_home_model.dart';

class UserServiceCard extends StatelessWidget {
  const UserServiceCard({super.key, required this.service});

  final UserHomeServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 0.92,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: 26.borderRadius,
            ),
            clipBehavior: Clip.antiAlias,
            child:
                Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomImage.rounded(
                      height: double.infinity,
                      imageUrl: service.imageUrl,
                      radius: 26,
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          borderRadius: 10.borderRadius,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CustomImage.square(
                              imageUrl: service.mobileIconUrl,
                              size: 16,
                              borderRadius: 4.borderRadius,
                            ),
                            8.gap,
                            Text(
                              service.name,
                              style: context.labelSmall.medium.s16,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ).flexible(),
                          ],
                        ),
                      ),
                    )
                        .paddingAll(12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: 26.borderRadius,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.06),
                            Colors.black.withValues(alpha: 0.26),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).setContainerToView(
                  borderWidth: 4,
                  borderColor: context.primarySwatch.shade100,
                  radius: 26,
                ),
          ),
        ),

        12.gap,
        Text(
          service.description,
          style: context.bodyLarge.regular.s16,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ).onTap(
      () => AppRoutes.singleService.push(extra: service),
      borderRadius: 26.borderRadius,
    );
  }
}
