import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../../data/model/order_model.dart';
import 'order_item_card.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({
    super.key,
    required this.orders,
  });

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
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
      padding: AppSize.screenPadding.edgeInsetsHorizontal + 20.edgeInsetsVertical,
      separator: 20.gap,
      itemBuilder: (context, index) => OrderItemCard(order: orders[index]),
    );
  }
}
