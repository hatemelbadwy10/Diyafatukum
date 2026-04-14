import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../../data/model/address_model.dart';
import '../../controller/addresses_cubit/addresses_cubit.dart';
import '../widgets/add_address_button.dart';
import '../widgets/address_tile.dart';
import 'address_details_screen.dart';
import 'map_screen.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddressesCubit>(),
      child: BlocBuilder<AddressesCubit, AddressesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar.build(titleText: LocaleKeys.addresses_title.tr()),
            bottomNavigationBar: state.status.isSuccess && state.addresses.isNotEmpty
                ? AddAddressButton(onAddressUpdated: () => AppRoutes.addresses.go()).toBottomNavBar()
                : null,
            body: state.status.build(
              onSuccess: (addresses) {
                return VerticalListView(
                  onRefresh: () async => context.read<AddressesCubit>().refresh(),
                  itemCount: addresses.length,
                  padding: EdgeInsets.symmetric(horizontal: AppSize.screenPadding, vertical: 12),
                  itemBuilder: (_, index) => AddressTile(address: addresses[index]),
                ).visible(
                  state.addresses.isNotEmpty,
                  fallback: CustomFallbackView(
                    icon: Assets.icons.ionLocationSharp.svg(),
                    title: LocaleKeys.addresses_empty_title.tr(),
                    subtitle: LocaleKeys.addresses_empty_subtitle.tr(),
                    buttonLabel: LocaleKeys.addresses_add.tr(),
                    onButtonPressed: () => AppRoutes.map.push(
                      extra: MapScreenArguments(
                        onLocationSelected: (LatLng position, Placemark placemark) {
                          AppRoutes.addressDetails.pushReplacement(
                            extra: AddressDetailsScreenArguments(
                              initialPosition: position,
                              placemark: placemark,
                              onAddressUpdated: (AddressModel address) {
                                AppRoutes.addresses.go();
                                context.read<AddressesCubit>().addAddress(address);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ).paddingBottom(context.height * 0.2),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
