import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/utils/geocoding_utils.dart';
import '../../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../../core/widgets/custom_check_box.dart';
import '../../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../../core/widgets/custom_selection_field.dart';
import '../../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../../core/widgets/image_selection_prompt.dart';
import '../../../../../../common/features/addresses/presentation/view/screens/map_screen.dart';
import '../../../../../../common/features/auth/presentation/view/widgets/auth_background_scaffold.dart';
import '../../../../../../common/features/settings/data/model/static_page_enum.dart';
import '../../../data/model/provider_register_request_model.dart';
import '../../controller/provider_register_cubit/provider_register_cubit.dart';

class ProviderRegisterLocationScreen extends StatefulWidget {
  const ProviderRegisterLocationScreen({
    super.key,
    required this.arguments,
  });

  final ProviderRegisterLocationArguments arguments;

  @override
  State<ProviderRegisterLocationScreen> createState() =>
      _ProviderRegisterLocationScreenState();
}

class _ProviderRegisterLocationScreenState
    extends State<ProviderRegisterLocationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _storeNameArController = TextEditingController();
  final TextEditingController _storeNameEnController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _whatsAppController = TextEditingController();
  final ValueNotifier<bool> _isTermsAccepted = ValueNotifier<bool>(false);

  String? _selectedCategory;
  File? _selectedLogo;
  LatLng? _selectedLatLng;
  Placemark? _selectedPlacemark;

  static const List<String> _categories = [
    'provider.register.categories.cakes',
    'provider.register.categories.flowers',
    'provider.register.categories.coffee',
  ];

  @override
  void initState() {
    super.initState();
    _storeNameArController.text = widget.arguments.request.storeNameAr ?? '';
    _storeNameEnController.text = widget.arguments.request.storeNameEn ?? '';
    _addressController.text = widget.arguments.request.address ?? '';
    _whatsAppController.text = widget.arguments.request.whatsapp ?? '';
    _selectedCategory = widget.arguments.request.storeCategory;
    _selectedLogo = widget.arguments.request.logo;
    if (widget.arguments.request.lat != null &&
        widget.arguments.request.long != null) {
      _selectedLatLng = LatLng(
        widget.arguments.request.lat!,
        widget.arguments.request.long!,
      );
    }
  }

  @override
  void dispose() {
    _storeNameArController.dispose();
    _storeNameEnController.dispose();
    _addressController.dispose();
    _whatsAppController.dispose();
    _isTermsAccepted.dispose();
    super.dispose();
  }

  Future<void> _openLocationPicker() async {
    await AppRoutes.map.push(
      extra: MapScreenArguments(
        initialPosition: _selectedLatLng,
        onLocationSelected: (LatLng position, Placemark placemark) {
          _selectedLatLng = position;
          _selectedPlacemark = placemark;
          _addressController.text = placemark.toAddressString();
          BaseRouter.pop();
          if (mounted) {
            setState(() {});
          }
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedLatLng == null || _selectedPlacemark == null) {
      Toaster.showToast(LocaleKeys.validator_location.tr());
      return;
    }
    if (_selectedLogo == null) {
      Toaster.showToast(LocaleKeys.validator_image.tr());
      return;
    }
    if (!_isTermsAccepted.value) {
      Toaster.showToast(LocaleKeys.auth_register_accept_terms_required.tr());
      return;
    }

    final request = widget.arguments.request.copyWith(
      storeNameAr: _storeNameArController.text.trim(),
      storeNameEn: _storeNameEnController.text.trim(),
      storeCategory: _selectedCategory,
      whatsapp: _whatsAppController.text.trim().neglectStartingZero,
      logo: _selectedLogo,
      address: _addressController.text.trim(),
      lat: _selectedLatLng!.latitude,
      long: _selectedLatLng!.longitude,
    );

    final locale = rootNavigatorKey.currentContext?.locale.languageCode ?? 'en';
    context.read<ProviderRegisterCubit>().register(await request.toBody(locale));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProviderRegisterCubit>(),
      child: BlocConsumer<ProviderRegisterCubit, ProviderRegisterState>(
        listener: (context, state) => state.status.listen(
          onSuccess: (_) {
            Toaster.showToast(
              LocaleKeys.provider_register_success.tr(),
              isError: false,
            );
            BaseRouter.popUntilPath(AppRoutes.providerHome.path);
          },
          onFailed: (failure) => Toaster.showToast(failure.message),
        ),
        builder: (context, state) {
          return AuthBackgroundScaffold(
            title: LocaleKeys.provider_register_store_title.tr(),
            bottom: CustomButton.gradient(
              borderRadius: AppSize.buttonBorderRadius,
              isLoading: state.status.isLoading,
              label: LocaleKeys.provider_register_submit.tr(),
              onPressed: _submit,
            ).setHero(HeroTags.mainButton),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.provider_register_store_subtitle.tr(),
                    textAlign: TextAlign.center,
                    style: context.bodyLarge.regular.s13.setHeight(1.6),
                  ),
                  24.gap,
                  ImageSelectionPrompt.single(
                    initialImageUrl: null,
                    isRequired: true,
                    height: 132,
                    width: 132,
                    borderRadius: 1000,
                    onImageSelected: (image) {
                      setState(() {
                        _selectedLogo = image;
                      });
                    },
                    icon: _StoreLogoPlaceholder(imageFile: _selectedLogo),
                  ).center(),
                  24.gap,
                  Row(
                    children: [
                      CustomTextField(
                        controller: _storeNameArController,
                        showRequiredIndicator: false,
                        title: LocaleKeys.provider_register_store_name_ar.tr(),
                        hint: LocaleKeys.provider_register_store_name_ar.tr()
                            .enterHint,
                        prefixIcon: Assets.icons.stashShopSolid.path,
                        inputType: InputType.textAr,
                      ).expand(),
                      12.gap,
                      CustomTextField(
                        controller: _storeNameEnController,
                        showRequiredIndicator: false,
                        title: LocaleKeys.provider_register_store_name_en.tr(),
                        hint: LocaleKeys.provider_register_store_name_en.tr()
                            .enterHint,
                        prefixIcon: Assets.icons.stashShopSolid.path,
                        inputType: InputType.textEn,
                      ).expand(),
                    ],
                  ),
                  16.gap,
                  CustomSelectionField<String>(
                    title: LocaleKeys.provider_register_store_category_title.tr(),
                    hint: LocaleKeys.provider_register_store_category_hint.tr(),
                    initialValue: _selectedCategory,
                    futureRequest: () async => _categories,
                    itemToString: (item) => item?.tr() ?? '',
                    onChanged: (value) => _selectedCategory = value,
                    validator: (value) => value == null
                        ? LocaleKeys.actions_select.tr(
                            args: [
                              LocaleKeys.provider_register_store_category_title
                                  .tr(),
                            ],
                          )
                        : null,
                    prefixWidget: Assets.icons.dropdownArrow
                        .svg(colorFilter: context.hintColor.colorFilter)
                        .center()
                        .withSize(20, 20),
                  ),
                  16.gap,
                  CustomTextField(
                    controller: _addressController,
                    showRequiredIndicator: false,
                    readOnly: true,
                    title: LocaleKeys.details_location_address.tr(),
                    hint: LocaleKeys.details_location_address.tr().enterHint,
                    suffixIcon: Assets.icons.ionLocationSharp.path,
                    onTap: _openLocationPicker,
                  ),
                  16.gap,
                  CustomTextField(
                    controller: _whatsAppController,
                    showRequiredIndicator: false,
                    title: LocaleKeys.details_contact_social_whatsapp.tr(),
                    hint: LocaleKeys.details_contact_social_whatsapp.tr()
                        .enterHint,
                    prefixIcon: Assets.icons.mdiPhoneOutline.path,
                    inputType: InputType.phone,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.left,
                  ),
                  12.gap,
                  CustomCheckBox(
                    initialValue: _isTermsAccepted.value,
                    onChanged: (value) => _isTermsAccepted.value = value,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleKeys.auth_register_accept_terms_title.tr(),
                          style: context.bodyLarge.regular.s12,
                        ),
                        4.gap,
                        CustomTextButton(
                          label: LocaleKeys.settings_terms.tr(),
                          textStyle: context.displayLarge.regular.underline.s12,
                          onPressed: () => AppRoutes.staticPage.push(
                            extra: StaticPage.terms,
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.gap,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProviderRegisterLocationArguments {
  const ProviderRegisterLocationArguments({required this.request});

  final ProviderRegisterRequestModel request;
}

class _StoreLogoPlaceholder extends StatelessWidget {
  const _StoreLogoPlaceholder({required this.imageFile});

  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 132,
          height: 132,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.surfaceColor,
            border: Border.all(
              color: context.scaffoldBackgroundColor,
              width: 8,
            ),
            image: DecorationImage(
              image: imageFile != null
                  ? FileImage(imageFile!)
                  : Assets.images.logoStoreLight.provider(),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: context.greySwatch.shade200.withValues(alpha: 0.6),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ).center(),
        Positioned.directional(
          end: 120,
          bottom: 6,
          textDirection: Directionality.of(context),
          child: Assets.icons.cameraAddFill
              .svg(
                width: 22,
                height: 22,
                colorFilter: context.onPrimary.colorFilter,
              )
              .setContainerToView(
                color: context.primaryColor,
                radius: 28,
                padding: 14,
              ),
        ),
      ],
    ).center();
  }
}
