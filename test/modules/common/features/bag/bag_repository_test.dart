import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:diyafatukum/modules/common/features/bag/data/datasource/bag_local_datasource.dart';
import 'package:diyafatukum/modules/common/features/bag/data/datasource/bag_remote_datasource.dart';
import 'package:diyafatukum/modules/common/features/bag/data/model/bag_model.dart';
import 'package:diyafatukum/modules/common/features/bag/data/model/checkout_request_model.dart';
import 'package:diyafatukum/modules/common/features/bag/data/repository/bag_repository.dart';

void main() {
  const item = BagItemModel(
    id: '11',
    productId: '11',
    name: 'Guest item',
    price: 25,
    imagePath: 'image.png',
    quantity: 2,
    storeId: '7',
  );

  late BagLocalDataSource localDataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    localDataSource = BagLocalDataSourceImpl(
      await SharedPreferences.getInstance(),
    );
  });

  test(
    'local bag preserves store id and excludes it from API request',
    () async {
      await localDataSource.saveBagItems(const [item]);

      final storedItem = localDataSource.getBagItems().single;

      expect(storedItem.storeId, '7');
      expect(storedItem.toCartItemRequest(), {'product_id': 11, 'quantity': 2});
    },
  );

  test('checkout request sends an existing address id', () {
    const request = CheckoutRequestModel(
      addressId: 14,
      occasionDate: '2026-06-25 18:00:00',
      notes: 'Call before arrival',
    );

    expect(request.toJson(), {
      'address_id': 14,
      'occasion_date': '2026-06-25 18:00:00',
      'notes': 'Call before arrival',
    });
  });

  test('checkout request sends a nested new address', () {
    const request = CheckoutRequestModel(
      newAddress: NewCheckoutAddressModel(
        label: 'Work',
        address: '123 Main Street, Cairo',
        latitude: 30.0444,
        longitude: 31.2357,
      ),
      occasionDate: '2026-06-25 18:00:00',
      notes: 'Call before arrival',
    );

    expect(request.toJson(), {
      'new_address': {
        'label': 'Work',
        'address': '123 Main Street, Cairo',
        'latitude': 30.0444,
        'longitude': 31.2357,
      },
      'occasion_date': '2026-06-25 18:00:00',
      'notes': 'Call before arrival',
    });
  });

  test('successful sync clears local bag', () async {
    await localDataSource.saveBagItems(const [item]);
    final repository = BagRepositoryImpl(
      _FakeBagRemoteDataSource(),
      localDataSource,
    );

    final result = await repository.syncLocalBag();

    expect(result.isRight(), isTrue);
    expect(localDataSource.getBagItems(), isEmpty);
  });

  test('failed sync keeps local bag', () async {
    await localDataSource.saveBagItems(const [item]);
    final repository = BagRepositoryImpl(
      _FakeBagRemoteDataSource(shouldFail: true),
      localDataSource,
    );

    final result = await repository.syncLocalBag();

    expect(result.isLeft(), isTrue);
    expect(localDataSource.getBagItems(), const [item]);
  });
}

class _FakeBagRemoteDataSource implements BagRemoteDataSource {
  const _FakeBagRemoteDataSource({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<Response> addItems(List<Map<String, dynamic>> items) async {
    if (shouldFail) {
      return Response(
        requestOptions: RequestOptions(path: '/user/cart/items'),
        statusCode: 400,
      );
    }
    return Response(
      requestOptions: RequestOptions(path: '/user/cart/items'),
      statusCode: 200,
      data: {
        'success': true,
        'data': {'items': items},
      },
    );
  }

  @override
  Future<Response> checkout(CheckoutRequestModel request) =>
      throw UnimplementedError();

  @override
  Future<Response> clearCart() => throw UnimplementedError();

  @override
  Future<Response> getBag() => throw UnimplementedError();

  @override
  Future<Response> removeItem(String itemId) => throw UnimplementedError();

  @override
  Future<Response> updateItemQuantity(String itemId, int quantity) =>
      throw UnimplementedError();
}
