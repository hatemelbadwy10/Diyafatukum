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
import '../../../../../../../core/widgets/buttons/custom_button.dart';
import '../../../../../../../core/widgets/close_icon_button.dart';
import '../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/widgets/date_picker_field.dart';
import '../../../../addresses/presentation/view/screens/map_screen.dart';
import '../../../../addresses/data/model/address_model.dart';
import '../../../../addresses/presentation/view/screens/address_details_screen.dart';
import '../../../../addresses/presentation/view/widgets/addresses_bottom_sheet.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../controller/bag_cubit/bag_cubit.dart';
import '../../../data/model/checkout_request_model.dart';
import '../../../data/repository/bag_repository.dart';

class BagCheckoutBottomSheet extends StatefulWidget {
  const BagCheckoutBottomSheet({
    super.key,
    this.authCubit,
    required this.bagCubit,
  });

  final AuthCubit? authCubit;
  final BagCubit bagCubit;

  @override
  State<BagCheckoutBottomSheet> createState() => _BagCheckoutBottomSheetState();
}

class _BagCheckoutBottomSheetState extends State<BagCheckoutBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _selectedDate;
  AddressModel? _selectedAddress;
  AddressModel? _newAddress;
  LatLng? _selectedLatLng;

  @override
  void initState() {
    super.initState();
    final address = widget.authCubit?.state.address;
    _selectedAddress = address;
    _selectedLatLng = address?.latLng;
    _addressController.text = address?.fullAddress ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = CustomBottomSheet(
      child: Form(
        key: _formKey,
        child:
            Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: context.greySwatch.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: CloseIconButton(onPressed: BaseRouter.pop),
                        ),
                        Text(
                          LocaleKeys.bag_checkout_title.tr(),
                          style: context.titleLarge.bold.s24,
                          textAlign: TextAlign.center,
                        ).expand(),
                        32.gap,
                      ],
                    ),
                    12.gap,
                    Text(
                      LocaleKeys.bag_checkout_subtitle.tr(),
                      style: context.bodyMedium.regular.setColor(
                        context.greySwatch.shade600,
                      ),
                    ),
                    24.gap,
                    DatePickerField(
                      title: LocaleKeys.details_date_time_date.tr(),
                      minDate: DateTime.now(),
                      initialValue: _selectedDate,
                      onChanged: (value) => _selectedDate = value,
                    ),
                    20.gap,
                    CustomTextField(
                      controller: _addressController,
                      title: LocaleKeys.bag_checkout_address_title.tr(),
                      hint: LocaleKeys.bag_checkout_address_select.tr(),
                      readOnly: true,
                      prefixIcon: Assets.icons.ionLocationSharp.path,
                      onTap: _openAddressPicker,
                    ),
                    20.gap,
                    CustomTextField(
                      controller: _notesController,
                      title: LocaleKeys.bag_checkout_notes_title.tr(),
                      hint: LocaleKeys.bag_checkout_notes_hint.tr(),
                      prefixIcon: Assets.icons.editSquare.path,
                      isRequired: false,
                    ),
                    24.gap,
                    CustomButton(
                      label: LocaleKeys.actions_confirm.tr(),
                      onPressed: _submit,
                    ),
                  ],
                )
                .paddingHorizontal(AppSize.screenPadding)
                .scrollable(padding: EdgeInsets.zero),
      ).paddingBottom(context.keyboardPadding),
    );

    if (widget.authCubit == null) {
      return content;
    }

    return BlocListener<AuthCubit, AuthState>(
      bloc: widget.authCubit,
      listener: (_, state) {
        if (_newAddress != null) return;
        _selectSavedAddress(state.address);
      },
      child: content,
    );
  }

  void _openAddressPicker() {
    final authCubit = widget.authCubit;
    if (authCubit == null) {
      _openNewLocationPicker();
      return;
    }

    context.showBottomSheet(
      BlocProvider.value(
        value: authCubit,
        child: AddressesBottomSheet(
          selectedAddressId: _selectedAddress?.id,
          onAddressSelected: _selectSavedAddress,
          onNewAddressSelected: _openNewLocationPicker,
        ),
      ),
    );
  }

  void _selectSavedAddress(AddressModel? address) {
    if (address == null) return;
    _selectedAddress = address;
    _newAddress = null;
    _selectedLatLng = address.latLng;
    _addressController.text = address.fullAddress;
    if (mounted) setState(() {});
  }

  Future<void> _openNewLocationPicker() async {
    await AppRoutes.map.push(
      extra: MapScreenArguments(
        initialPosition: _selectedLatLng,
        onLocationSelected: (LatLng position, Placemark placemark) {
          AppRoutes.addressDetails.pushReplacement(
            extra: AddressDetailsScreenArguments(
              initialPosition: position,
              placemark: placemark,
              onAddressCompleted: _selectNewAddress,
              requireAddressLabel: true,
            ),
          );
        },
      ),
    );
  }

  void _selectNewAddress(AddressModel address) {
    _selectedAddress = null;
    _newAddress = address;
    _selectedLatLng = address.latLng;
    _addressController.text = address.detailedAddress;
    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final selectedDate = _selectedDate;
    if (selectedDate == null) return;
    if (_selectedLatLng == null || _addressController.text.trim().isEmpty) {
      Toaster.showToast(LocaleKeys.validator_location.tr());
      return;
    }

    final selectedAddress = _selectedAddress;
    final newAddress = _newAddress;
    if (selectedAddress == null && newAddress == null) return;

    final result = await sl<BagRepository>().checkout(
      CheckoutRequestModel(
        addressId: selectedAddress?.id,
        newAddress: newAddress != null
            ? NewCheckoutAddressModel(
                label: newAddress.label,
                address: newAddress.detailedAddress,
                latitude: newAddress.lat,
                longitude: newAddress.lng,
              )
            : null,
        occasionDate: selectedDate.format(
          format: 'yyyy-MM-dd HH:mm:ss',
          enableLocalization: false,
        ),
        notes: _notesController.text.trim(),
      ),
    );

    if (!mounted) return;

    result.fold((failure) => Toaster.showToast(failure.message), (
      response,
    ) async {
      await widget.bagCubit.loadBag();
      widget.authCubit?.updateUserCartStoreId(null);
      if (!mounted) return;
      BaseRouter.pop();
      Toaster.showToast(
        response.message?.trim().isNotEmpty == true
            ? response.message!
            : LocaleKeys.bag_checkout_order_success_title.tr(),
        isError: false,
      );
    });
  }
}
