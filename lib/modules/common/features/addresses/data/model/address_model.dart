import 'package:equatable/equatable.dart';
import 'address_type_enum.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

AddressModel addressFromJson(dynamic json) => AddressModel.fromJson(json);

List<AddressModel> addressesFromJson(dynamic json) {
  final source = json is Map<String, dynamic>
      ? json['addresses'] ?? json['data'] ?? const []
      : json;
  return List<AddressModel>.from(
    (source as List).map((x) => AddressModel.fromJson(x)),
  );
}

class AddressModel extends Equatable {
  final int id;
  final String buildingNumber;
  final String apartmentNumber;
  final String floorNumber;
  final String streetName;
  final String landmark;
  final String area;
  final double lat;
  final double lng;
  final AddressType type;
  final String label;
  final bool isDefault;
  final num deliveryFees;

  LatLng get latLng => LatLng(lat, lng);

  String get detailedAddress {
    return [
      if (buildingNumber.isNotEmpty) buildingNumber,
      if (apartmentNumber.isNotEmpty) apartmentNumber,
      if (floorNumber.isNotEmpty) floorNumber,
      if (streetName.isNotEmpty) streetName,
      if (area.isNotEmpty) area,
      if (landmark.isNotEmpty) landmark,
    ].join(', ');
  }

  String get fullAddress {
    final addressParts = [
      // if (buildingNumber.isNotEmpty) buildingNumber,
      // if (apartmentNumber.isNotEmpty) apartmentNumber,
      // if (floorNumber.isNotEmpty) floorNumber,
      if (streetName.isNotEmpty) streetName,
      if (area.isNotEmpty) area,
      // if (landmark.isNotEmpty) landmark,
    ].where((part) => part.isNotEmpty);

    if (addressParts.isNotEmpty) return addressParts.join(', ');
    if (label.isNotEmpty) return label;
    return 'Address not available';
  }

  factory AddressModel.fromForm({
    required String buildingNumber,
    required String apartmentNumber,
    required String floorNumber,
    required String streetName,
    required String landmark,
    required String area,
    required double lat,
    required double lng,
    required AddressType type,
    required String label,
  }) {
    return AddressModel(
      id: 0,
      buildingNumber: buildingNumber,
      apartmentNumber: apartmentNumber,
      floorNumber: floorNumber,
      streetName: streetName,
      landmark: landmark,
      area: area,
      lat: lat,
      lng: lng,
      type: type,
      label: label,
      isDefault: false,
      deliveryFees: 0,
    );
  }

  const AddressModel({
    required this.id,
    required this.buildingNumber,
    required this.apartmentNumber,
    required this.floorNumber,
    required this.streetName,
    required this.landmark,
    required this.area,
    required this.lat,
    required this.lng,
    required this.type,
    required this.label,
    required this.isDefault,
    required this.deliveryFees,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: int.tryParse(json["id"].toString()) ?? 0,
    buildingNumber: _stringValue(json, const [
      'building_number',
      'building_no',
      'building',
    ]),
    apartmentNumber: _stringValue(json, const [
      'appartement_number',
      'apartment_number',
      'apartment_no',
      'apartment',
    ]),
    floorNumber: _stringValue(json, const [
      'floor_number',
      'floor_no',
      'floor',
    ]),
    streetName: _stringValue(json, const [
      'street_name',
      'street',
      'address_line',
      'address',
    ]),
    landmark: _stringValue(json, const [
      'landmark',
      'additional_directions',
      'additional_info',
    ]),
    area: _stringValue(json, const ['area', 'district', 'city']),
    lat: double.tryParse((json["latitude"] ?? json["lat"]).toString()) ?? 0,
    lng:
        double.tryParse(
          (json["longitude"] ?? json["long"] ?? json["lng"]).toString(),
        ) ??
        0,
    type: AddressType.fromValue(
      (json["type"] ?? json["label"] ?? '').toString().toLowerCase(),
    ),
    label: (json["label"] ?? json["address"] ?? '').toString(),
    isDefault: json["is_default"] ?? false,
    deliveryFees: num.tryParse(json["delivery_price"].toString()) ?? 0,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'building_number': buildingNumber,
      'appartement_number': apartmentNumber,
      'floor_number': floorNumber,
      'street_name': streetName,
      'landmark': landmark,
      'area': area,
      'lat': lat.toString(),
      'long': lng.toString(),
      'type': type.name,
      'address': label,
      'is_default': isDefault,
      'delivery_price': deliveryFees,
    };
  }

  const AddressModel.empty()
    : id = 0,
      buildingNumber = '',
      apartmentNumber = '',
      floorNumber = '',
      streetName = '',
      landmark = '',
      area = '',
      lat = 0.0,
      lng = 0.0,
      type = AddressType.home,
      label = '',
      isDefault = false,
      deliveryFees = 0;

  AddressModel copyWith({
    int? id,
    String? buildingNumber,
    String? apartmentNumber,
    String? floorNumber,
    String? streetName,
    String? landmark,
    String? area,
    double? lat,
    double? lng,
    AddressType? type,
    String? label,
    bool? isDefault,
    num? deliveryFees,
  }) {
    return AddressModel(
      id: id ?? this.id,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      floorNumber: floorNumber ?? this.floorNumber,
      streetName: streetName ?? this.streetName,
      landmark: landmark ?? this.landmark,
      area: area ?? this.area,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      type: type ?? this.type,
      label: label ?? this.label,
      isDefault: isDefault ?? this.isDefault,
      deliveryFees: deliveryFees ?? this.deliveryFees,
    );
  }

  @override
  List<Object?> get props => [
    id,
    buildingNumber,
    apartmentNumber,
    floorNumber,
    streetName,
    landmark,
    area,
    lat,
    lng,
    type,
    label,
    isDefault,
    deliveryFees,
  ];
}

String _stringValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key]?.toString().trim();
    if (value != null && value.isNotEmpty && value != 'null') {
      return value;
    }
  }
  return '';
}
