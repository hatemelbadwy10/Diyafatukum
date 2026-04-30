import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/widgets/custom_arrow_back.dart';
import '../../../data/model/provider_store_model.dart';

class ProviderStoreHeader extends StatelessWidget {
  const ProviderStoreHeader({
    super.key,
    required this.store,
    required this.onEditTap,
  });

  final ProviderStoreModel store;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final canPop = GoRouter.of(context).canPop();

    return Stack(
      children: [
        SizedBox(
          height: 305,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(store.coverImagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.62),
                  ],
                ),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: MediaQuery.paddingOf(context).top + 10,
          start: AppSize.screenPadding,
          end: AppSize.screenPadding,
          child: Row(
            children: [
              if (canPop)
                const CustomArrowBack(iconColor: Colors.white)
              else
                const SizedBox(width: 40, height: 40),
              const Spacer(),
              Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.tablerEdit.svg(
                        width: 18,
                        height: 18,
                        colorFilter: context.onPrimary.colorFilter,
                      ),
                      8.gap,
                      Text(
                        LocaleKeys.provider_store_edit.tr(),
                        style: context.titleSmall.bold.setColor(context.onPrimary),
                      ),
                    ],
                  )
                  .paddingSymmetric(16, 12)
                  .setContainerToView(
                    radius: 10,
                    gradient: GradientStyles.primaryGradient,
                  )
                  .onTap(onEditTap, borderRadius: 10.borderRadius),
            ],
          ),
        ),
        PositionedDirectional(
          start: AppSize.screenPadding,
          end: AppSize.screenPadding,
          bottom: 26,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              16.gap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.category,
                    style: context.bodySmall.regular.s14.setColor(
                      context.scaffoldBackgroundColor.withValues(alpha: 0.82),
                    ),
                  ),
                  4.gap,
                  Text(
                    store.name,
                    style: context.titleLarge.bold.setFontSize(30).setColor(context.scaffoldBackgroundColor),
                  ),
                  6.gap,
                  Row(
                    children: [
                      Assets.icons.ionLocationSharp.svg(
                        width: 16,
                        height: 16,
                        colorFilter: context.scaffoldBackgroundColor.colorFilter,
                      ),
                      6.gap,
                      Text(
                        store.location,
                        style: context.bodyMedium.regular.s16.setColor(context.scaffoldBackgroundColor),
                      ),
                    ],
                  ),
                ],
              ).expand(),
                 Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF25D366),
                  shape: BoxShape.circle,
                ),
                child: Assets.icons.whats.svg(
                  width: 24,
                  height: 24,
                  colorFilter: Colors.white.colorFilter,
                ).center(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
