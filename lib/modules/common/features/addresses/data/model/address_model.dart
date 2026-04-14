import 'package:equatable/equatable.dart';
import 'address_type_enum.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

AddressModel addressFromJson(dynamic json) => AddressModel.fromJson(json);

List<AddressModel> addressesFromJson(dynamic json) {
  return List<AddressModel>.from(json.map((x) => AddressModel.fromJson(x)));
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

  String get fullAddress {
    if (label.isNotEmpty) return label;

    final addressParts = [
      // if (buildingNumber.isNotEmpty) buildingNumber,
      // if (apartmentNumber.isNotEmpty) apartmentNumber,
      // if (floorNumber.isNotEmpty) floorNumber,
      if (streetName.isNotEmpty) streetName,
      if (area.isNotEmpty) area,
      // if (landmark.isNotEmpty) landmark,
    ].where((part) => part.isNotEmpty);

    return addressParts.isEmpty ? 'Address not available' : addressParts.join(', ');
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
    id: json["id"],
    buildingNumber: json["building_number"] ?? '',
    apartmentNumber: json["appartement_number"] ?? '',
    floorNumber: json["floor_number"] ?? '',
    streetName: json["street_name"] ?? '',
    landmark: json["landmark"] ?? '',
    area: json["area"] ?? '',
    lat: double.parse(json["lat"].toString()),
    lng: double.parse(json["long"].toString()),
    type: AddressType.fromValue(json["type"]),
    label: json["address"] ?? '',
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
