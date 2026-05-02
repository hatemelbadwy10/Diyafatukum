import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/resources/type_defs.dart';
import '../datasource/orders_remote_datasource.dart';
import '../model/order_model.dart';

abstract class OrdersRepository {
  Result<List<OrderModel>> getOrders(OrderTabStatus status);
}

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl(this.remoteDataSource);

  final OrdersRemoteDataSource remoteDataSource;

  @override
  Result<List<OrderModel>> getOrders(OrderTabStatus status) async {
    return remoteDataSource.getOrders(status).toResult(ordersFromJson);
  }
}
