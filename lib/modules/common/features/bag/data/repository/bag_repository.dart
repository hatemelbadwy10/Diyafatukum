import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/data/models/base_response.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/bag_remote_datasource.dart';
import '../model/bag_model.dart';

abstract class BagRepository {
  Result<BagModel> getBag();
  Result<BagModel> addItems(List<BagItemModel> items);
  Result updateItemQuantity(String itemId, int quantity);
  Result clearCart();
  Result removeItem(String itemId);
  Result checkout(BodyMap body);
}

@LazySingleton(as: BagRepository)
class BagRepositoryImpl implements BagRepository {
  const BagRepositoryImpl(this.remoteDataSource);

  final BagRemoteDataSource remoteDataSource;

  @override
  Result<BagModel> getBag() {
    return remoteDataSource.getBag().toResult(bagModelFromJson);
  }

  @override
  Result<BagModel> addItems(List<BagItemModel> items) {
    return remoteDataSource
        .addItems(items.map((item) => item.toCartItemRequest()).toList())
        .toResult(bagModelFromJson);
  }

  @override
  Result updateItemQuantity(String itemId, int quantity) {
    return remoteDataSource
        .updateItemQuantity(itemId, quantity)
        .toResult(noDataFromJson);
  }

  @override
  Result clearCart() {
    return remoteDataSource.clearCart().toResult(noDataFromJson);
  }

  @override
  Result removeItem(String itemId) {
    return remoteDataSource.removeItem(itemId).toResult(noDataFromJson);
  }

  @override
  Result checkout(BodyMap body) {
    return remoteDataSource.checkout(body).toResult(noDataFromJson);
  }
}
