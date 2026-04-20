import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/resources/type_defs.dart';
import '../datasource/orders_remote_datasource.dart';
import '../model/order_model.dart';

abstract class OrdersRepository {
  Result<List<OrderModel>> getOrders();
}

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl(this.remoteDataSource);

  final OrdersRemoteDataSource remoteDataSource;

  @override
  Result<List<OrderModel>> getOrders() async {
    return remoteDataSource.getOrders().toResult(ordersFromJson);
  }
}
