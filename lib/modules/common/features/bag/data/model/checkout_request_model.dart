import 'package:equatable/equatable.dart';

class CheckoutRequestModel extends Equatable {
  const CheckoutRequestModel({
    required this.occasionDate,
    required this.notes,
    this.addressId,
    this.newAddress,
  }) : assert(
         (addressId == null) != (newAddress == null),
         'Exactly one checkout address must be provided.',
       );

  final int? addressId;
  final NewCheckoutAddressModel? newAddress;
  final String occasionDate;
  final String notes;

  Map<String, dynamic> toJson() {
    return {
      if (addressId != null) 'address_id': addressId,
      if (newAddress != null) 'new_address': newAddress!.toJson(),
      'occasion_date': occasionDate,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [addressId, newAddress, occasionDate, notes];
}

class NewCheckoutAddressModel extends Equatable {
  const NewCheckoutAddressModel({
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final String address;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [label, address, latitude, longitude];
}
