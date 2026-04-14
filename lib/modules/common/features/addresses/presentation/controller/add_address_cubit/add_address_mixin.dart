import 'package:deals/core/utils/geocoding_utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../core/resources/type_defs.dart';

import '../../../data/model/address_model.dart';
import '../../../data/model/address_type_enum.dart';

mixin AddAddressMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController buildingNumberController = TextEditingController();
  final TextEditingController apartmentNumberController = TextEditingController();
  final TextEditingController floorNumberController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ValueNotifier<String> areaController = ValueNotifier<String>('');
  final ValueNotifier<AddressType> addressType = ValueNotifier<AddressType>(AddressType.home);
  final ValueNotifier<LatLng> latLngNotifier = ValueNotifier<LatLng>(LatLng(0, 0));

  bool isFormValid() => formKey.currentState?.validate() ?? false;

  void setAddressType(AddressType type) => addressType.value = type;

  void setLatLng(LatLng? location) => latLngNotifier.value = location ?? LatLng(0, 0);

  BodyMap get body {
    return {
      'lat': latLngNotifier.value.latitude.toString(),
      'long': latLngNotifier.value.longitude.toString(),
      'type': addressType.value.name,
      'area': areaController.value,
      'building_number': buildingNumberController.text,
      'appartement_number': apartmentNumberController.text,
      'floor_number': floorNumberController.text,
      'street_name': streetNameController.text,
      'landmark': landmarkController.text,
      'address': addressController.text,
    };
  }

  void initControllers(AddressModel? address) {
    if (address != null) {
      buildingNumberController.text = address.buildingNumber.toString();
      apartmentNumberController.text = address.apartmentNumber.toString();
      floorNumberController.text = address.floorNumber.toString();
      streetNameController.text = address.streetName;
      landmarkController.text = address.landmark;
      areaController.value = address.area;
      addressController.text = address.label;
      setAddressType(address.type);
      setLatLng(address.latLng);
    }
  }

  void onLocationSelectedFromMap(LatLng? latLng, Placemark? placemark) {
    if (latLng == null || placemark == null) return;
    setLatLng(latLng);

    areaController.value = placemark.areaName;

    streetNameController.text = placemark.street ?? '';
  }

  void disposeControllers() {
    buildingNumberController.dispose();
    apartmentNumberController.dispose();
    floorNumberController.dispose();
    streetNameController.dispose();
    landmarkController.dispose();
    areaController.dispose();
    addressController.dispose();
  }
}
