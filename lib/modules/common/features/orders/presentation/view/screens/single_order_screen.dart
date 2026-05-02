import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../data/model/order_model.dart';
import '../widgets/provider_order_status_card.dart';
import '../widgets/single_order_info_tile.dart';
import '../widgets/single_order_section_card.dart';

class SingleOrderScreen extends StatelessWidget {
  const SingleOrderScreen({
    super.key,
    required this.order,
    this.isProviderView = false,
  });

  final OrderModel order;
  final bool isProviderView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar.build(
        titleText: order.id,
        titleStyle: context.titleMedium.bold,
        backgroundColor: context.scaffoldBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleOrderSectionCard(
            title: LocaleKeys.orders_single_store_title.tr(),
            children: [
              SingleOrderInfoTile(
                icon: Assets.icons.stashShopSolid.path.toSvg(
                  width: 64,
                  height: 64,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_single_store_name.tr(),
                value: order.storeName,
              ),
              SingleOrderInfoTile(
                icon: Assets.icons.mdiPhoneOutline.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_single_store_phone.tr(),
                value: order.storePhone,
              ),
            ],
          ),
          28.gap,
          SingleOrderSectionCard(
            title: LocaleKeys.orders_details_title.tr(),
            children: [
              SingleOrderInfoTile(
                icon: Assets.icons.iconParkOutlineTransactionOrder.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_details_items.tr(),
                value: order.itemsSummary.join('\n'),
              ),
              SingleOrderInfoTile(
                icon: Assets.icons.fluentMdl2DateTime2.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.details_date_time_date.tr(),
                value: order.dateLabel,
              ),
              SingleOrderInfoTile(
                icon: Assets.icons.ionLocationSharp.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_details_address.tr(),
                value: order.address,
              ),
              SingleOrderInfoTile(
                icon: Assets.icons.editSquare.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_single_notes.tr(),
                value: order.notes,
              ),
            ],
          ),
          28.gap,
          SingleOrderSectionCard(
            title: LocaleKeys.orders_single_payment_title.tr(),
            children: [
              SingleOrderInfoTile(
                icon: Assets.icons.materialSymbolsLightAttachMoney.path.toSvg(
                  width: 28,
                  height: 28,
                  color: context.primaryColor,
                ),
                title: LocaleKeys.orders_single_payment_total_paid.tr(),
                value: '${order.totalPaid.toStringAsFixed(0)} SAR',
              ),
            ],
          ),
          if (isProviderView) ...[
            28.gap,
            Text(
              LocaleKeys.orders_details_status_title.tr(),
              style: context.titleMedium.semiBold.s16.setColor(
                context.colorScheme.onSurface,
              ),
            ),
            20.gap,
            ...order.timeline.map(
              (step) => ProviderOrderStatusCard(step: step).paddingBottom(16),
            ),
          ],
        ],
      ).withListView(padding: AppSize.screenPadding.edgeInsetsWithBottomNavBar),
    );
  }
}
