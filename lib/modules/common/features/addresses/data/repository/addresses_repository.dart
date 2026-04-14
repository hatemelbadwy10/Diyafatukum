import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/data/models/base_response.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/addresses_remote_datasource.dart';
import '../model/address_model.dart';

abstract class AddressesRepository {
  Result<List<AddressModel>> getAddresses();
  Result<AddressModel> getAddressDetails(String id);
  Result<AddressModel> addAddress(BodyMap body);
  Result<AddressModel> updateAddress(BodyMap body);
  Result deleteAddress(String id);
  Result setDefaultAddress(String id);
}

@LazySingleton(as: AddressesRepository)
class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesRemoteDataSource remoteDataSource;
  const AddressesRepositoryImpl(this.remoteDataSource);

  @override
  Result<List<AddressModel>> getAddresses() {
    return remoteDataSource.getAddresses().toResult(addressesFromJson);
  }

  @override
  Result<AddressModel> getAddressDetails(String id) {
    return remoteDataSource.getAddressDetails(id).toResult(addressFromJson);
  }

  @override
  Result<AddressModel> addAddress(BodyMap body) {
    return remoteDataSource.addAddress(body).toResult(addressFromJson);
  }

  @override
  Result<AddressModel> updateAddress(BodyMap body) {
    return remoteDataSource.updateAddress(body).toResult(addressFromJson);
  }

  @override
  Result deleteAddress(String id) {
    return remoteDataSource.deleteAddress(id).toResult(noDataFromJson);
  }

  @override
  Result setDefaultAddress(String id) {
    return remoteDataSource.setDefaultAddress(id).toResult(noDataFromJson);
  }
}
