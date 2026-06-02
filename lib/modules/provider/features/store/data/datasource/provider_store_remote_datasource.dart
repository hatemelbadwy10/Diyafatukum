import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';
import '../../../../../../core/resources/type_defs.dart';

abstract class ProviderStoreRemoteDataSource {
  Future<Response> getStore();
  Future<Response> getCategories();
  Future<Response> getProducts({String? categoryId});
  Future<Response> createProduct(FormData body);
  Future<Response> updateProduct(String productId, FormData body);
  Future<Response> deleteProduct(String productId);
  Future<Response> createCategory(Map<String, dynamic> body);
  Future<Response> updateStore(FormData body);
  Future<Response> updateStoreDescription(FormData body);
}

@LazySingleton(as: ProviderStoreRemoteDataSource)
class ProviderStoreRemoteDataSourceImpl
    implements ProviderStoreRemoteDataSource {
  const ProviderStoreRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> getStore() async {
    return client.get(RemoteUrls.profile);
  }

  @override
  Future<Response> getCategories() {
    return client.get(RemoteUrls.providerCategories);
  }

  @override
  Future<Response> getProducts({String? categoryId}) {
    final ParamsMap params = categoryId == null ? null : {'cat_id': categoryId};
    return client.get(RemoteUrls.providerProducts, queryParameters: params);
  }

  @override
  Future<Response> createProduct(FormData body) {
    return client.post(
      RemoteUrls.providerProducts,
      data: body,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<Response> updateProduct(String productId, FormData body) {
    return client.post(
      RemoteUrls.providerProduct(productId),
      data: body,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<Response> deleteProduct(String productId) {
    return client.delete(RemoteUrls.providerProduct(productId));
  }

  @override
  Future<Response> createCategory(Map<String, dynamic> body) {
    return client.post(RemoteUrls.providerCategories, data: body);
  }

  @override
  Future<Response> updateStore(FormData body) {
    return client.post(
      RemoteUrls.providerStore,
      data: body,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<Response> updateStoreDescription(FormData body) {
    return client.post(
      RemoteUrls.providerStoreDescription,
      data: body,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
