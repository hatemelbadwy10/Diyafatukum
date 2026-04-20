import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../data/model/order_model.dart';
import '../../controller/orders_cubit/orders_cubit.dart';
import '../widgets/orders_list_view.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        appBar: CustomAppBar.build(
          titleText: LocaleKeys.orders_title.tr(),
          titleStyle: context.titleMedium.bold,
          backgroundColor: context.scaffoldBackgroundColor,
       
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            final cubit = context.read<OrdersCubit>();

            return state.status.build(
              onLoading: () => const CustomLoading(),
              onFailed: () => CustomFallbackView(
                title: LocaleKeys.error_ops.tr(),
                subtitle: state.status.message,
                buttonLabel: LocaleKeys.actions_retry.tr(),
                onButtonPressed: cubit.loadOrders,
              ),
              onSuccess: (_) => Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: LocaleKeys.orders_tabs_current.tr()),
                      Tab(text: LocaleKeys.orders_tabs_completed.tr()),
                      Tab(text: LocaleKeys.orders_tabs_cancelled.tr()),
                    ],
                  ).paddingHorizontal(AppSize.screenPadding),
                  8.gap,
                  TabBarView(
                    children: [
                      OrdersListView(
                        orders: state.byStatus(OrderTabStatus.current),
                      ),
                      OrdersListView(
                        orders: state.byStatus(OrderTabStatus.completed),
                      ),
                      OrdersListView(
                        orders: state.byStatus(OrderTabStatus.cancelled),
                      ),
                    ],
                  ).expand(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
