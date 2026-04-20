import 'package:injectable/injectable.dart';

import '../datasource/bag_local_datasource.dart';
import '../model/bag_model.dart';

abstract class BagRepository {
  BagModel getBag();
  Future<void> addItems(List<BagItemModel> items);
  Future<void> removeItem(String itemId);
  Future<void> clearBag();
}

@LazySingleton(as: BagRepository)
class BagRepositoryImpl implements BagRepository {
  const BagRepositoryImpl(this.localDataSource);

  final BagLocalDataSource localDataSource;

  @override
  BagModel getBag() {
    return BagModel(items: localDataSource.getBagItems());
  }

  @override
  Future<void> addItems(List<BagItemModel> items) async {
    final currentItems = [...localDataSource.getBagItems()];

    for (final item in items) {
      final index = currentItems.indexWhere((current) => current.id == item.id);
      if (index == -1) {
        currentItems.add(item);
      } else {
        final current = currentItems[index];
        currentItems[index] = current.copyWith(
          quantity: current.quantity + item.quantity,
        );
      }
    }

    await localDataSource.saveBagItems(currentItems);
  }

  @override
  Future<void> removeItem(String itemId) async {
    final currentItems = localDataSource
        .getBagItems()
        .where((item) => item.id != itemId)
        .toList();
    await localDataSource.saveBagItems(currentItems);
  }

  @override
  Future<void> clearBag() async {
    await localDataSource.clearBag();
  }
}
