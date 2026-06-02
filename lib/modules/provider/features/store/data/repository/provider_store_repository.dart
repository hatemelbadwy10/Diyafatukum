import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/data/models/base_response.dart';
import '../../../../../../core/resources/type_defs.dart';
import '../datasource/provider_store_remote_datasource.dart';
import '../model/provider_store_model.dart';
import '../model/provider_store_request_model.dart';

abstract class ProviderStoreRepository {
  Result<ProviderStoreModel> getStore();
  Result<List<ProviderStoreProductModel>> getProducts({String? categoryId});
  Result createProduct(ProviderStoreProductRequestModel request);
  Result updateProduct(
    String productId,
    ProviderStoreProductRequestModel request,
  );
  Result deleteProduct(String productId);
  Result createCategory(ProviderStoreCategoryRequestModel request);
  Result updateStore(ProviderStoreUpdateRequestModel request);
  Result updateStoreDescription(ProviderStoreDescriptionRequestModel request);
}

@LazySingleton(as: ProviderStoreRepository)
class ProviderStoreRepositoryImpl implements ProviderStoreRepository {
  const ProviderStoreRepositoryImpl(this.remoteDataSource);

  final ProviderStoreRemoteDataSource remoteDataSource;

  @override
  Result<ProviderStoreModel> getStore() async {
    try {
      final profileResponse = await remoteDataSource.getStore();
      final categoriesResponse = await remoteDataSource.getCategories();
      final productsResponse = await remoteDataSource.getProducts();

      final storeResponse = parseBaseResponse(
        profileResponse.data,
        providerStoreFromJson,
      );
      final categoriesResponseModel = parseBaseResponse(
        categoriesResponse.data,
        providerStoreCategoriesFromJson,
      );
      final productsResponseModel = parseBaseResponse(
        productsResponse.data,
        providerStoreProductsFromJson,
      );

      final store = storeResponse.data;
      if (store == null) {
        return Left(ErrorHandler.handle('Store data is missing').failure);
      }

      final categories = [
        const ProviderStoreCategoryModel(id: 'all', name: 'All'),
        ...?categoriesResponseModel.data,
      ];

      final composedStore = store.copyWith(
        categories: categories,
        products: productsResponseModel.data ?? const [],
      );

      return Right(
        BaseResponse<ProviderStoreModel>(
          success: storeResponse.success,
          message: storeResponse.message,
          data: composedStore,
        ),
      );
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Result<List<ProviderStoreProductModel>> getProducts({String? categoryId}) {
    return remoteDataSource
        .getProducts(categoryId: categoryId)
        .toResult(providerStoreProductsFromJson);
  }

  @override
  Result createProduct(ProviderStoreProductRequestModel request) async {
    return remoteDataSource
        .createProduct(await request.toFormData())
        .toResult(noDataFromJson);
  }

  @override
  Result updateProduct(
    String productId,
    ProviderStoreProductRequestModel request,
  ) async {
    return remoteDataSource
        .updateProduct(productId, await request.toFormData())
        .toResult(noDataFromJson);
  }

  @override
  Result deleteProduct(String productId) async {
    return remoteDataSource.deleteProduct(productId).toResult(noDataFromJson);
  }

  @override
  Result createCategory(ProviderStoreCategoryRequestModel request) async {
    return remoteDataSource
        .createCategory(request.toBody())
        .toResult(noDataFromJson);
  }

  @override
  Result updateStore(ProviderStoreUpdateRequestModel request) async {
    return remoteDataSource
        .updateStore(await request.toFormData())
        .toResult(noDataFromJson);
  }

  @override
  Result updateStoreDescription(
    ProviderStoreDescriptionRequestModel request,
  ) async {
    return remoteDataSource
        .updateStoreDescription(await request.toFormData())
        .toResult(noDataFromJson);
  }
}
