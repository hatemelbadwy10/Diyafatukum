import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/debouncer.dart';
import '../../../../../../../core/utils/geocoding_utils.dart';
import '../../../../../../../core/utils/location_utils.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.arguments});

  final MapScreenArguments? arguments;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _fallbackPosition = LatLng(24.7136, 46.6753);

  GoogleMapController? _mapController;
  late LatLng _selectedPosition;

  Placemark? _selectedPlacemark;
  String _selectedAddress = '';
  bool _isLoadingAddress = true;
  bool _isLoadingCurrentLocation = false;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.arguments?.initialPosition ?? _fallbackPosition;
    _initializeLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    if (widget.arguments?.initialPosition != null) {
      await _resolveAddress(_selectedPosition);
      return;
    }
    await _moveToCurrentLocation(showError: false);
    if (_selectedAddress.isEmpty) {
      await _resolveAddress(_selectedPosition);
    }
  }

  Future<void> _moveToCurrentLocation({bool showError = true}) async {
    if (mounted) {
      setState(() => _isLoadingCurrentLocation = true);
    }

    final result = await sl<LocationService>().getCurrentLocation();
    await result.fold((failure) async {
      if (showError) {
        Toaster.showToast(failure.message);
      }
    }, (position) async {
      _hasLocationPermission = true;
      _selectedPosition = LatLng(position.latitude, position.longitude);
      await _mapController?.animateCamera(CameraUpdate.newLatLng(_selectedPosition));
      await _resolveAddress(_selectedPosition);
    });

    if (mounted) {
      setState(() => _isLoadingCurrentLocation = false);
    }
  }

  Future<void> _resolveAddress(LatLng position) async {
    if (mounted) {
      setState(() => _isLoadingAddress = true);
    }

    final placemark = await GeocodingUtils.getPlacemarkFromLatLng(position);
    final address = await GeocodingUtils.getFullAddressFromLatLng(position);

    if (!mounted) return;

    setState(() {
      _selectedPosition = position;
      _selectedPlacemark = placemark;
      _selectedAddress = address ?? '';
      _isLoadingAddress = false;
    });
  }

  void _confirmSelection() {
    if (_selectedPlacemark == null) {
      Toaster.showToast(LocaleKeys.validator_location.tr());
      return;
    }
    widget.arguments?.onLocationSelected?.call(_selectedPosition, _selectedPlacemark!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(
        titleText: LocaleKeys.addresses_details_map_title.tr(),
        onLeadingPressed: () => BaseRouter.pop(),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.addresses_details_map_deliver.tr(),
                style: context.bodyMedium.regular.s14,
              ),
              4.gap,
              if (_isLoadingAddress)
                Text(
                  LocaleKeys.actions_calculating.tr(),
                  style: context.titleMedium.regular.s12,
                )
              else
                Text(
                  _selectedAddress.isEmpty
                      ? LocaleKeys.validator_location.tr()
                      : _selectedAddress,
                  style: context.titleMedium.regular.s12,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ).setContainerToView(
            padding: 12,
            radius: AppSize.mainRadius,
            color: context.surfaceColor,
            shadows: ShadowStyles.cardShadow,
          ),
          12.gap,
          CustomButton.gradient(
            label: LocaleKeys.addresses_details_map_confirm.tr(),
            onPressed: _confirmSelection,
          ),
        ],
      ).toBottomNavBar(),
      body: Stack(
        children: [
          GoogleMap(
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: _hasLocationPermission,
            initialCameraPosition: CameraPosition(target: _selectedPosition, zoom: 16),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraMove: (position) {
              _selectedPosition = position.target;
            },
            onCameraIdle: () {
              Debouncer.instance.run(() => _resolveAddress(_selectedPosition));
            },
          ),
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: Assets.icons.ionLocationSharp.svg(
                  width: 40,
                  height: 40,
                  colorFilter: context.primaryColor.colorFilter,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 16,
            end: 16,
            child: CustomIconButton.svg(
              svg: Assets.icons.ionLocationSharp,
              onPressed: _isLoadingCurrentLocation ? null : _moveToCurrentLocation,
              backgroundColor: context.scaffoldBackgroundColor,
              foregroundColor: context.primaryColor,
              borderRadius: 999,
              padding: 12.edgeInsetsAll,
              size: 18,
            ).setContainerToView(
              radius: 999,
              shadows: ShadowStyles.cardShadow,
            ),
          ),
        ],
      ),
    );
  }
}

class MapScreenArguments {
  MapScreenArguments({this.initialPosition, this.onLocationSelected});

  final LatLng? initialPosition;
  final void Function(LatLng position, Placemark placemark)? onLocationSelected;
}
