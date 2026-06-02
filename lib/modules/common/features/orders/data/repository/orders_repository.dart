import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/models/base_response.dart';
import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/resources/type_defs.dart';
import '../datasource/orders_remote_datasource.dart';
import '../model/order_model.dart';

abstract class OrdersRepository {
  Result<List<OrderModel>> getOrders(OrderTabStatus status);
  Result<Unit> cancelOrder(String id, String reason);
  Result<Unit> acceptProviderOrder(String id);
  Result<Unit> rejectProviderOrder(String id, String reason);
  Result<Unit> advanceProviderOrderStatus(String id, String status);
}

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl(this.remoteDataSource);

  final OrdersRemoteDataSource remoteDataSource;

  @override
  Result<List<OrderModel>> getOrders(OrderTabStatus status) async {
    return remoteDataSource.getOrders(status).toResult(ordersFromJson);
  }

  @override
  Result<Unit> cancelOrder(String id, String reason) async {
    return remoteDataSource.cancelOrder(id, reason).toResult(noDataFromJson);
  }

  @override
  Result<Unit> acceptProviderOrder(String id) async {
    return remoteDataSource.acceptProviderOrder(id).toResult(noDataFromJson);
  }

  @override
  Result<Unit> rejectProviderOrder(String id, String reason) async {
    return remoteDataSource
        .rejectProviderOrder(id, reason)
        .toResult(noDataFromJson);
  }

  @override
  Result<Unit> advanceProviderOrderStatus(String id, String status) async {
    return remoteDataSource
        .advanceProviderOrderStatus(id, status)
        .toResult(noDataFromJson);
  }
}
