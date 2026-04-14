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
import '../../../../../../../core/widgets/custom_animated_container.dart';
import '../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../data/model/address_model.dart';
import '../../controller/add_address_cubit/add_address_cubit.dart';
import '../../controller/addresses_cubit/addresses_cubit.dart';
import '../../controller/default_address_cubit/default_address_cubit.dart';
import '../screens/address_details_screen.dart';
import '../screens/map_screen.dart';
import 'add_address_button.dart';
import 'address_selection_indicator.dart';
import 'address_tile.dart';

class AddressesBottomSheet extends StatelessWidget {
  const AddressesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AddressesCubit>()),
        BlocProvider(create: (context) => sl<AddAddressCubit>()),
        BlocProvider(create: (context) => sl<DefaultAddressCubit>()),
      ],
      child: CustomAnimatedContainer(
        curve: Curves.linearToEaseOut,
        child: BlocBuilder<AddressesCubit, AddressesState>(
          builder: (context, state) {
            return state.status.build(
              onLoading: () => const CustomLoading().setContainerToView(
                color: context.scaffoldBackgroundColor,
                height: context.height * 0.35,
              ),
              onSuccess: (addresses) {
                return CustomBottomSheet(
                  child: BlocConsumer<AddAddressCubit, AddAddressState>(
                    listener: (context, addState) {
                      addState.status.listen(
                        onFailed: (error) => Toaster.showToast(error.message),
                        onSuccess: (address) {
                          context.read<AuthCubit>().updateUserAddress(address);
                          Toaster.showToast(LocaleKeys.addresses_success_default.tr(), isError: false);
                        },
                      );
                    },
                    builder: (context, addState) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(LocaleKeys.addresses_select.tr(), style: context.bodyLarge.regular.s14).expand(),
                              CustomTextButton(label: LocaleKeys.actions_done.tr(), onPressed: () => BaseRouter.pop()),
                            ],
                          ).paddingHorizontal(AppSize.screenPadding),
                          4.gap,
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, authState) {
                              return VerticalListView(
                                padding: EdgeInsets.zero,
                                itemCount: state.addresses.length,
                                separator: Divider(
                                  height: 0,
                                  indent: AppSize.screenPadding + 48,
                                  color: context.primaryDividerColor,
                                ),
                                itemBuilder: (_, index) {
                                  final address = state.addresses[index];
                                  return AddressTile(
                                    address: address,
                                    padding: AppSize.screenPadding,
                                    backgroundColor: context.scaffoldBackgroundColor,
                                    trailing: AddressSelectionIndicator(address: address),
                                    onTap: () {
                                      if (addState.status.isLoading ||
                                          authState.address?.isDefault == true && authState.address?.id == address.id) {
                                        return;
                                      } else {
                                        context.read<DefaultAddressCubit>().setDefaultAddress(address);
                                      }
                                    },
                                  );
                                },
                              ).expand();
                            },
                          ),
                          AddAddressButton(
                            onAddressUpdated: () {
                              if (BaseRouter.contains(AppRoutes.checkout.name)) {
                                BaseRouter.pop();
                                BaseRouter.pop();
                                return;
                              }
                              AppRoutes.home.go();
                              BaseRouter.pop();
                            },
                          ).paddingHorizontal(AppSize.screenPadding).paddingTop(8),
                        ],
                      ).withHeight(context.height * 0.75);
                    },
                  ),
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
                                if (BaseRouter.contains(AppRoutes.checkout.name)) {
                                  BaseRouter.pop();
                                  BaseRouter.pop();
                                  return;
                                }
                                AppRoutes.home.go();
                                BaseRouter.pop();
                                context.read<AddressesCubit>().addAddress(address);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ).paddingBottom(140).withHeight(context.height * 0.75),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
