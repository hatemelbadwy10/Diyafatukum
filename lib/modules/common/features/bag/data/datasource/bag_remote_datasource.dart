import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';
import '../../../../../../core/resources/type_defs.dart';

abstract class BagRemoteDataSource {
  Future<Response> getBag();
  Future<Response> addItems(List<Map<String, dynamic>> items);
  Future<Response> updateItemQuantity(String itemId, int quantity);
  Future<Response> clearCart();
  Future<Response> removeItem(String itemId);
  Future<Response> checkout(BodyMap body);
}

@LazySingleton(as: BagRemoteDataSource)
class BagRemoteDataSourceImpl implements BagRemoteDataSource {
  const BagRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> getBag() => client.get(RemoteUrls.cart);

  @override
  Future<Response> addItems(List<Map<String, dynamic>> items) {
    return client.post(RemoteUrls.cartItems, data: {'items': items});
  }

  @override
  Future<Response> updateItemQuantity(String itemId, int quantity) {
    return client.put(
      RemoteUrls.cartItem(itemId),
      data: {'quantity': quantity},
    );
  }

  @override
  Future<Response> clearCart() => client.delete(RemoteUrls.cart);

  @override
  Future<Response> removeItem(String itemId) =>
      client.delete(RemoteUrls.cartItem(itemId));

  @override
  Future<Response> checkout(BodyMap body) =>
      client.post(RemoteUrls.checkout, data: body);
}
