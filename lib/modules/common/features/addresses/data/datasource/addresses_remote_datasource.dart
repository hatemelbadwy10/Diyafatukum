import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';
import '../../../../../../../core/resources/type_defs.dart';

abstract class AddressesRemoteDataSource {
  Future<Response> getAddresses();
  Future<Response> getAddressDetails(String id);
  Future<Response> addAddress(BodyMap body);
  Future<Response> updateAddress(BodyMap body);
  Future<Response> deleteAddress(String id);
  Future<Response> setDefaultAddress(String id);
}

@LazySingleton(as: AddressesRemoteDataSource)
class AddressesRemoteDataSourceImpl implements AddressesRemoteDataSource {
  final ApiClient client;
  const AddressesRemoteDataSourceImpl(this.client);

  @override
  Future<Response> getAddresses() => client.get(RemoteUrls.addresses);

  @override
  Future<Response> getAddressDetails(String id) => client.get(RemoteUrls.address(id));

  @override
  Future<Response> addAddress(BodyMap body) => client.post(RemoteUrls.addresses, data: body);

  @override
  Future<Response> updateAddress(BodyMap body) => client.put(RemoteUrls.address(body['id']), data: body);

  @override
  Future<Response> deleteAddress(String id) => client.delete(RemoteUrls.address(id));

  @override
  Future<Response> setDefaultAddress(String id) {
    return client.post(RemoteUrls.setDefaultAddress(id), data: {'is_default': 1});
  }
}
