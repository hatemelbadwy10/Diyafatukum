import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';

import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../data/model/address_model.dart';
import '../../controller/addresses_cubit/addresses_cubit.dart';
import '../screens/address_details_screen.dart';
import '../screens/map_screen.dart';

class AddAddressButton extends StatelessWidget {
  const AddAddressButton({super.key, this.onAddressUpdated});

  final void Function()? onAddressUpdated;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: LocaleKeys.addresses_add.tr(),
      onPressed: () => AppRoutes.map.push(
        extra: MapScreenArguments(
          onLocationSelected: (LatLng position, Placemark placemark) {
            AppRoutes.addressDetails.pushReplacement(
              extra: AddressDetailsScreenArguments(
                initialPosition: position,
                placemark: placemark,
                onAddressUpdated: (AddressModel address) {
                  onAddressUpdated?.call();
                  context.read<AddressesCubit>().addAddress(address);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
