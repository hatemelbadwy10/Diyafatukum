import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/data/client/api_client.dart';
import '../../../../../../../core/resources/constants/localization_constants.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../controller/language_cubit/language_cubit.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  final ValueNotifier<Locale?> _selectedLocale = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    _selectedLocale.value ??= context.locale;
    return BlocProvider(
      create: (context) => sl<LanguageCubit>(),
      child: BlocConsumer<LanguageCubit, LanguageState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            _onLanguageChanged();
          }
        },
        builder: (context, state) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              return CustomBottomSheet(
                title: LocaleKeys.settings_language_title.tr(),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LocaleKeys.settings_language_subtitle.tr(), style: context.bodyMedium.s16),
                    ValueListenableBuilder(
                      valueListenable: _selectedLocale,
                      builder: (context, value, child) {
                        return Row(
                          spacing: 16,
                          textDirection: ui.TextDirection.rtl,
                          children: LocalizationConstants.supportedLocales.map((locale) {
                            final bool isSelected = value == locale;
                            return Column(
                              textDirection: ui.TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                locale.languageCode == 'ar'
                                    ? Assets.icons.fluentMail28Regular.svg(height: 24)
                                    : Assets.icons.fluentMail28Regular.svg(height: 32),
                                Text(
                                  locale.languageCode == 'ar' ? 'العربية' : 'English',
                                  style: isSelected ? context.bodyLarge.s16.medium : context.bodySmall.s16.regular,
                                ),
                              ],
                            )
                                .center()
                                .onTap(() {
                                  _selectedLocale.value = locale;
                                }, borderRadius: AppSize.mainRadius.borderRadius)
                                .setContainerToView(
                                  height: 100,
                                  borderColor: isSelected ? null : context.inputFieldBorderColor,
                                  radius: AppSize.mainRadius,
                                  color: isSelected ? context.secondaryContainerColor : null,
                                )
                                .expand();
                          }).toList(),
                        );
                      },
                    ),
                    SizedBox.shrink(),
                    CustomButton(
                      isLoading: state.status.isLoading,
                      label: LocaleKeys.actions_save_changes.tr(),
                      onPressed: () {
                        if (authState.status.isAuthorized) {
                          context.read<LanguageCubit>().changeLanguage(_selectedLocale.value?.languageCode ?? 'ar');
                        } else {
                          _onLanguageChanged();
                        }
                      },
                    ),
                  ],
                ).paddingHorizontal(AppSize.screenPadding),
              );
            },
          );
        },
      ),
    );
  }

  void _onLanguageChanged() {
    context.setLocale(_selectedLocale.value!);
    sl<ApiClient>().updateLanguage(_selectedLocale.value!.languageCode);
    context.pop();
    AppRoutes.splash.go();
  }
}
