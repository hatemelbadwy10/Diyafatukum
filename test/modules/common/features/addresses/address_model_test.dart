import 'package:flutter_test/flutter_test.dart';

import 'package:diyafatukum/modules/common/features/addresses/data/model/address_model.dart';
import 'package:diyafatukum/modules/common/features/addresses/data/model/address_type_enum.dart';

void main() {
  test('parses checkout address latitude and longitude fields', () {
    final address = AddressModel.fromJson({
      'id': 14,
      'label': 'Work',
      'address': '123 Main Street, Cairo',
      'latitude': 30.0444,
      'longitude': 31.2357,
    });

    expect(address.id, 14);
    expect(address.fullAddress, '123 Main Street, Cairo');
    expect(address.label, 'Work');
    expect(address.streetName, '123 Main Street, Cairo');
    expect(address.lat, 30.0444);
    expect(address.lng, 31.2357);
  });

  test('parses address detail field aliases for edit form', () {
    final address = AddressModel.fromJson({
      'id': 14,
      'building': '25',
      'apartment_number': '8',
      'floor': '3',
      'street': 'Muhammad Bin Al Thahabi St',
      'additional_directions': 'Near the park',
      'district': 'Al Worood',
      'latitude': 24.7,
      'longitude': 46.6,
    });

    expect(address.buildingNumber, '25');
    expect(address.apartmentNumber, '8');
    expect(address.floorNumber, '3');
    expect(address.streetName, 'Muhammad Bin Al Thahabi St');
    expect(address.landmark, 'Near the park');
    expect(address.area, 'Al Worood');
  });

  test('builds complete checkout address from form fields', () {
    final address = AddressModel.fromForm(
      buildingNumber: '25',
      apartmentNumber: '8',
      floorNumber: '3',
      streetName: 'Muhammad Bin Al Thahabi St',
      landmark: 'Near the park',
      area: 'Al Worood',
      lat: 24.7,
      lng: 46.6,
      type: AddressType.work,
      label: 'Work',
    );

    expect(address.label, 'Work');
    expect(
      address.detailedAddress,
      '25, 8, 3, Muhammad Bin Al Thahabi St, Al Worood, Near the park',
    );
    expect(address.lat, 24.7);
    expect(address.lng, 46.6);
  });
}
