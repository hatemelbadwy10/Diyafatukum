import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../data/model/address_model.dart';
import '../../controller/add_address_cubit/add_address_cubit.dart';
import '../../controller/add_address_cubit/add_address_mixin.dart';
import '../widgets/address_types_field.dart';
import 'map_screen.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key, this.arguments});

  final AddressDetailsScreenArguments? arguments;

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> with AddAddressMixin {
  late final GoogleMapController mapController;
  late final bool isEdit;

  @override
  void initState() {
    isEdit = widget.arguments?.address != null;
    initControllers(widget.arguments?.address);
    onLocationSelectedFromMap(widget.arguments?.initialPosition, widget.arguments?.placemark);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<AddAddressCubit>())],
      child: BlocConsumer<AddAddressCubit, AddAddressState>(
        listener: (context, state) => state.status.listen(
          onSuccess: (address) {
            widget.arguments?.onAddressUpdated?.call(address);
            final defaultAddress = context.read<AuthCubit>().state.user.address;
            if ((isEdit && defaultAddress != null && defaultAddress.id == address.id) || !isEdit) {
              context.read<AuthCubit>().updateUserAddress(address);
            }
            Toaster.showToast(state.status.message, isError: false);
          },
          onFailed: (error) => Toaster.showToast(error.message),
        ),
        builder: (context, formState) {
          final addCubit = context.read<AddAddressCubit>();
          return Scaffold(
            appBar: CustomAppBar.build(
              onLeadingPressed: () => BaseRouter.pop(),
              titleText: isEdit ? LocaleKeys.addresses_edit.tr() : LocaleKeys.addresses_add.tr(),
            ),
            bottomNavigationBar: CustomButton(
              isLoading: formState.status.isLoading,
              label: isEdit ? LocaleKeys.actions_save_changes.tr() : LocaleKeys.actions_save.tr(),
              onPressed: () {
                if (isFormValid()) {
                  addCubit.addAddress(
                    isEdit: isEdit,
                    body: body..addAll({'id': widget.arguments?.address?.id.toString()}),
                  );
                }
              },
            ).toBottomNavBar(),
            body: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                    valueListenable: latLngNotifier,
                    builder: (context, latLng, child) {
                      return Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(zoom: 14, target: latLng),
                            myLocationEnabled: true,
                            mapToolbarEnabled: false,
                            tiltGesturesEnabled: false,
                            zoomControlsEnabled: false,
                            zoomGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            myLocationButtonEnabled: false,
                            onMapCreated: (controller) {
                              mapController = controller;
                              mapController.animateCamera(CameraUpdate.newLatLng(latLng));
                            },
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.icons.ionLocationSharp.svg(
                                  width: 40,
                                  height: 40,
                                  colorFilter: context.primaryColor.colorFilter,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).withHeight(140);
                    },
                  ),
                  16.gap,
                  ValueListenableBuilder(
                    valueListenable: areaController,
                    builder: (context, area, child) {
                      return Row(
                        children: [
                          Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 4,
                                children: [
                                  Assets.icons.ionLocationSharp.svg(
                                    height: 14,
                                    colorFilter: context.bodySmall.color?.colorFilter,
                                  ),
                                  Text(LocaleKeys.addresses_details_label_area.tr(), style: context.bodySmall.s12),
                                ],
                              ),
                              Text(area, style: context.bodyLarge.s14),
                            ],
                          ).expand(),
                          CustomTextButton(
                            label: LocaleKeys.actions_edit.tr(),
                            onPressed: () => AppRoutes.map.push(
                              extra: MapScreenArguments(
                                initialPosition: latLngNotifier.value,
                                onLocationSelected: (LatLng position, Placemark placemark) {
                                  BaseRouter.pop();
                                  mapController.animateCamera(CameraUpdate.newLatLng(position));
                                  onLocationSelectedFromMap(position, placemark);
                                },
                              ),
                            ),
                          ),
                        ],
                      ).setContainerToView(
                        padding: 8,
                        radius: AppSize.mainRadius,
                        color: context.surfaceColor,
                        shadows: ShadowStyles.cardShadow,
                      );
                    },
                  ),
                  32.gap,
                  AddressTypesField(
                    initialValue: widget.arguments?.address?.type,
                    onChanged: (type) => addressType.value = type,
                  ),
                  16.gap,
                  Column(
                    spacing: 16,
                    children: [
                      CustomTextField(
                        controller: buildingNumberController,
                        title: LocaleKeys.addresses_details_label_building.tr(),
                        hint: LocaleKeys.addresses_details_hint_building.tr(),
                      ),
                      Row(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: apartmentNumberController,
                            title: LocaleKeys.addresses_details_label_apartment.tr(),
                            hint: LocaleKeys.addresses_details_hint_apartment.tr(),
                          ).flexible(),
                          CustomTextField(
                            isRequired: false,
                            controller: floorNumberController,
                            title: LocaleKeys.addresses_details_label_floor.tr(),
                            hint: LocaleKeys.addresses_details_hint_floor.tr(),
                          ).flexible(),
                        ],
                      ),
                      CustomTextField(
                        isRequired: true,
                        controller: streetNameController,
                        title: LocaleKeys.addresses_details_label_street.tr(),
                        hint: LocaleKeys.addresses_details_hint_street.tr(),
                      ),
                      CustomTextField(
                        isRequired: false,
                        controller: landmarkController,
                        title: LocaleKeys.addresses_details_label_additional.tr(),
                        hint: LocaleKeys.addresses_details_hint_additional.tr(),
                      ),
                      CustomTextField(
                        isRequired: false,
                        controller: addressController,
                        title: LocaleKeys.addresses_details_label_title.tr(),
                        hint: LocaleKeys.addresses_details_hint_title.tr(),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Assets.icons.iconoirProfileCircle.svg(height: 20, colorFilter: context.greySwatch.shade700.colorFilter),
                      Text(
                        LocaleKeys.addresses_details_hint_info.tr(),
                        style: context.bodyLarge.s12,
                      ).paddingLeft(8).flexible(),
                    ],
                  ).paddingTop(8),
                ],
              ).withListView(),
            ),
          );
        },
      ),
    );
  }
}

class AddressDetailsScreenArguments {
  final LatLng? initialPosition;
  final Placemark? placemark;
  final AddressModel? address;
  final void Function(AddressModel)? onAddressUpdated;

  AddressDetailsScreenArguments({this.initialPosition, this.placemark, this.address, this.onAddressUpdated});
}
