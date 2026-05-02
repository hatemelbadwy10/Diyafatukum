import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../data/model/order_model.dart';
import '../../controller/orders_cubit/orders_cubit.dart';
import '../widgets/orders_list_view.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChanged)
      ..dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (_tabController.indexIsChanging ||
        _tabController.index == _selectedIndex) {
      return;
    }
    _loadTab(_tabController.index);
  }

  void _loadTab(int index) {
    _selectedIndex = index;
    context.read<OrdersCubit>().loadOrders(_statusByIndex(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar.build(
        titleText: LocaleKeys.orders_title.tr(),
        titleStyle: context.titleMedium.bold,
        backgroundColor: context.scaffoldBackgroundColor,
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                onTap: _loadTab,
                tabs: [
                  Tab(text: LocaleKeys.orders_tabs_current.tr()),
                  Tab(text: LocaleKeys.orders_tabs_completed.tr()),
                  Tab(text: LocaleKeys.orders_tabs_cancelled.tr()),
                ],
              ).paddingHorizontal(AppSize.screenPadding),
              8.gap,
              TabBarView(
                controller: _tabController,
                children: [
                  _OrdersTabView(status: OrderTabStatus.current, state: state),
                  _OrdersTabView(
                    status: OrderTabStatus.completed,
                    state: state,
                  ),
                  _OrdersTabView(
                    status: OrderTabStatus.cancelled,
                    state: state,
                  ),
                ],
              ).expand(),
            ],
          );
        },
      ),
    );
  }

  OrderTabStatus _statusByIndex(int index) {
    switch (index) {
      case 1:
        return OrderTabStatus.completed;
      case 2:
        return OrderTabStatus.cancelled;
      default:
        return OrderTabStatus.current;
    }
  }
}

class _OrdersTabView extends StatelessWidget {
  const _OrdersTabView({required this.status, required this.state});

  final OrderTabStatus status;
  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersCubit>();
    final isSelectedStatus = state.selectedStatus == status;

    if (state.status.isLoading && isSelectedStatus) {
      return const OrdersListView.loading();
    }

    if (state.status.isFailed && isSelectedStatus) {
      return CustomFallbackView(
        title: LocaleKeys.error_ops.tr(),
        subtitle: state.status.message,
        buttonLabel: LocaleKeys.actions_retry.tr(),
        onButtonPressed: () => cubit.loadOrders(status),
      );
    }

    return OrdersListView(orders: state.byStatus(status));
  }
}
