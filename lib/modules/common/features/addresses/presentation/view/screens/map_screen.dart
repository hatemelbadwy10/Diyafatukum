// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// import '../../../../../../../core/config/extensions/all_extensions.dart';
// import '../../../../../../../core/config/service_locator/injection.dart';
// import '../../../../../../../core/resources/resources.dart';
// import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
// import '../../../../../../../core/widgets/custom_app_bar.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key, this.arguments});
//   final MapScreenArguments? arguments;

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController _mapController;
//   bool _isProgrammaticMove = false;

//   late final LatLng? _initialPosition;

//   @override
//   void initState() {
//     final LocationCubit locationCubit = context.read<LocationCubit>();
//     _initialPosition =
//         widget.arguments?.initialPosition ?? locationCubit.state.currentUserLocation ?? LatLng(31.0403885, 31.3645642);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _mapController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<AddressCheckCubit>(),
//       child: BlocConsumer<LocationCubit, LocationState>(
//         listenWhen: (previous, current) => previous.position != current.position,
//         listener: (context, state) {
//           state.position.listen(
//             onSuccess: (data) {
//               _isProgrammaticMove = true;
//               _mapController.animateCamera(CameraUpdate.newLatLng(data)).then((_) {
//                 Future.delayed(const Duration(milliseconds: 500), () => _isProgrammaticMove = false);
//               });
//             },
//           );
//         },
//         builder: (context, state) {
//           return BlocConsumer<AddressCheckCubit, AddressCheckState>(
//             listener: (context, checkState) {
//               checkState.status.listen(
//                 onSuccess: (data) {
//                   context.read<LocationCubit>().updateLocation(data);
//                 },
//               );
//             },
//             builder: (context, checkState) {
//               return Scaffold(
//                 appBar: CustomAppBar.build(titleText: LocaleKeys.addresses_details_map_title.tr()),
//                 body: Stack(
//                   children: [
//                     if (_initialPosition != null)
//                       GoogleMap(
//                         mapToolbarEnabled: false,
//                         myLocationButtonEnabled: false,
//                         zoomControlsEnabled: false,
//                         onMapCreated: (controller) {
//                           _mapController = controller;
//                         },
//                         initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14),
//                         onCameraMove: (position) {
//                           if (_isProgrammaticMove) return;
//                           Debouncer.instance.run(() => context.read<AddressCheckCubit>().checkAddress(position.target));
//                         },
//                       ),
//                     Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Assets.icons.locationPinFilled.svg(
//                             width: 40,
//                             height: 40,
//                             colorFilter: context.primaryColor.colorFilter,
//                           ),
//                           const SizedBox(height: 40),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: BlocBuilder<LocationCubit, LocationState>(
//                         builder: (context, state) {
//                           final address = state.address;
//                           final position = state.position.data;
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               CustomIconButton(
//                                 borderRadius: 100,
//                                 foregroundColor: context.primaryColor,
//                                 icon: CupertinoIcons.location_fill,
//                                 backgroundColor: context.surfaceColor,
//                                 onPressed: () => context.read<LocationCubit>().getCurrentLocation(),
//                               ).setContainerToView(
//                                 radius: 100,
//                                 shadows: ShadowStyles.cardShadow,
//                                 margin: AppSize.screenPadding,
//                               ),
//                               Container(
//                                 color: context.scaffoldBackgroundColor,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     CustomAnimatedContainer(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                                         children: [
//                                           if (state.position.isLoading || checkState.status.isLoading)
//                                             Skeletonizer(
//                                               enabled: true,
//                                               child: Column(
//                                                 spacing: 8,
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Container(
//                                                     height: 10,
//                                                     width: 120,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(100),
//                                                       color: context.secondaryContainerColor,
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                     height: 12,
//                                                     width: 240,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(100),
//                                                       color: context.secondaryContainerColor,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ).paddingVertical(4),
//                                             )
//                                           else ...[
//                                             Text(
//                                               !checkState.status.isFailed
//                                                   ? LocaleKeys.addresses_details_map_deliver.tr()
//                                                   : LocaleKeys.addresses_details_map_zone_title.tr(),
//                                               style: context.bodyMedium.regular.s14.copyWith(
//                                                 color: !checkState.status.isFailed ? null : context.errorColor,
//                                               ),
//                                             ),
//                                             Text(
//                                               !checkState.status.isFailed
//                                                   ? address
//                                                   : LocaleKeys.addresses_details_map_zone_message.tr(),
//                                               style: context.titleMedium.s12.regular,
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ],
//                                         ],
//                                       ).paddingVertical(8),
//                                     ),
//                                     CustomButton(
//                                       isLoading: state.position.isLoading || checkState.status.isLoading,
//                                       enabled: state.position.isSuccess && !checkState.status.isFailed,
//                                       label: LocaleKeys.addresses_details_map_confirm.tr(),
//                                       onPressed: address.isEmpty
//                                           ? null
//                                           : () {
//                                               if (widget.arguments?.onLocationSelected != null && position != null) {
//                                                 widget.arguments!.onLocationSelected!(position, state.placemark);
//                                               }
//                                             },
//                                     ).setHero(HeroTags.mainButton),
//                                   ],
//                                 ),
//                               ).toBottomNavBar(),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenArguments {
  final LatLng? initialPosition;
  final void Function(LatLng position, Placemark)? onLocationSelected;

  MapScreenArguments({this.initialPosition, this.onLocationSelected});
}
