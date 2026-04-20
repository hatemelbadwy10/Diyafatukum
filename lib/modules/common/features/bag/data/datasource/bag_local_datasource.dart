import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../core/resources/constants/pref_keys.dart';
import '../model/bag_model.dart';

abstract class BagLocalDataSource {
  List<BagItemModel> getBagItems();
  Future<void> saveBagItems(List<BagItemModel> items);
  Future<void> clearBag();
}

@LazySingleton(as: BagLocalDataSource)
class BagLocalDataSourceImpl implements BagLocalDataSource {
  const BagLocalDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  List<BagItemModel> getBagItems() {
    return bagItemsFromStorage(sharedPreferences.getString(PrefKeys.bag));
  }

  @override
  Future<void> saveBagItems(List<BagItemModel> items) async {
    await sharedPreferences.setString(PrefKeys.bag, bagItemsToJson(items));
  }

  @override
  Future<void> clearBag() async {
    await sharedPreferences.remove(PrefKeys.bag);
  }
}
