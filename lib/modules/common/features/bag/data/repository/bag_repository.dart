import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/data/models/base_response.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/bag_remote_datasource.dart';
import '../datasource/bag_local_datasource.dart';
import '../model/bag_model.dart';
import '../model/checkout_request_model.dart';

abstract class BagRepository {
  Result<BagModel> getBag();
  Result<BagModel> addItems(List<BagItemModel> items);
  Result<BagModel> updateItemQuantity(String itemId, int quantity);
  Result clearCart();
  Result removeItem(String itemId);
  Result checkout(CheckoutRequestModel request);
  List<BagItemModel> getLocalBagItems();
  Future<void> saveLocalBagItems(List<BagItemModel> items);
  Future<void> clearLocalBag();
  Result<BagModel> syncLocalBag();
}

@LazySingleton(as: BagRepository)
class BagRepositoryImpl implements BagRepository {
  const BagRepositoryImpl(this.remoteDataSource, this.localDataSource);

  final BagRemoteDataSource remoteDataSource;
  final BagLocalDataSource localDataSource;

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
  Result<BagModel> updateItemQuantity(String itemId, int quantity) {
    return remoteDataSource
        .updateItemQuantity(itemId, quantity)
        .toResult(bagModelFromJson);
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
  Result checkout(CheckoutRequestModel request) {
    return remoteDataSource.checkout(request).toResult(noDataFromJson);
  }

  @override
  List<BagItemModel> getLocalBagItems() => localDataSource.getBagItems();

  @override
  Future<void> saveLocalBagItems(List<BagItemModel> items) {
    return localDataSource.saveBagItems(items);
  }

  @override
  Future<void> clearLocalBag() => localDataSource.clearBag();

  @override
  Result<BagModel> syncLocalBag() async {
    final items = localDataSource.getBagItems();
    if (items.isEmpty) {
      return getBag();
    }

    final result = await addItems(items);
    await result.fold((_) async {}, (_) => localDataSource.clearBag());
    return result;
  }
}
