import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/shimmer_widget.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../../data/model/order_model.dart';
import 'order_item_card.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({super.key, required this.orders}) : isLoading = false;

  const OrdersListView.loading({super.key})
    : orders = const [],
      isLoading = true;

  final List<OrderModel> orders;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return VerticalListView(
        itemCount: 3,
        padding:
            AppSize.screenPadding.edgeInsetsHorizontal + 20.edgeInsetsVertical,
        separator: 20.gap,
        itemBuilder: (context, index) => const _OrderItemCardSkeleton(),
      );
    }

    if (orders.isEmpty) {
      return CustomFallbackView(
        icon: Assets.icons.letsIconsOrder.svg(
          width: 72,
          height: 72,
          colorFilter: context.primaryColor.colorFilter,
        ),
        title: LocaleKeys.orders_empty_title.tr(),
        subtitle: LocaleKeys.orders_empty_subtitle.tr(),
        buttonLabel: LocaleKeys.orders_empty_action.tr(),
        onButtonPressed: () => AppRoutes.home.go(),
      );
    }

    return VerticalListView(
      itemCount: orders.length,
      padding:
          AppSize.screenPadding.edgeInsetsHorizontal + 20.edgeInsetsVertical,
      separator: 20.gap,
      itemBuilder: (context, index) => OrderItemCard(order: orders[index]),
    );
  }
}

class _OrderItemCardSkeleton extends StatelessWidget {
  const _OrderItemCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 18.edgeInsetsAll,
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        borderRadius: 20.borderRadius,
        border: Border.all(color: context.greySwatch.shade100),
        boxShadow: ShadowStyles.bottomSheetShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              ShimmerWidget.rectangular(width: 90, height: 18, borderRadius: 6),
              const Spacer(),
              ShimmerWidget.rectangular(
                width: 120,
                height: 18,
                borderRadius: 6,
              ),
            ],
          ),
          18.gap,
          Row(
            children: [
              ShimmerWidget.rectangular(
                width: 84,
                height: 84,
                borderRadius: 12,
              ),
              12.gap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(
                    width: double.infinity,
                    height: 18,
                    borderRadius: 6,
                  ),
                  10.gap,
                  ShimmerWidget.rectangular(
                    width: 140,
                    height: 16,
                    borderRadius: 6,
                  ),
                ],
              ).expand(),
            ],
          ),
          24.gap,
          Row(
            children: List.generate(
              5,
              (index) => Column(
                children: [
                  ShimmerWidget.circular(radius: 16),
                  10.gap,
                  ShimmerWidget.rectangular(
                    width: 64,
                    height: 14,
                    borderRadius: 6,
                  ),
                ],
              ).expand(),
            ),
          ),
        ],
      ),
    );
  }
}
