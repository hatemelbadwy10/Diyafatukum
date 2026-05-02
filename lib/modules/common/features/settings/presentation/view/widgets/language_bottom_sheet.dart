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
import '../../../../../../../core/widgets/close_icon_button.dart';
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
              return Container(
                decoration: BoxDecoration(
                  color: context.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(34),
                  ),
                ),
                child:
                    Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                         
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              

                                  Text(
                              LocaleKeys.settings_language_title.tr(),
                              style: context.displaySmall.bold.s18,
                            ).center().expand(),
                            
                              CloseIconButton(
                                  onPressed: context.pop,
                                ).setContainerToView(
                                  padding: 8,
                                  width: 32,
                                  height: 32,
                                  color: context.greySwatch.shade100,
                                  radius: 22,
                                ),
                              ],
                            ),
                            8.gap,
                          
                            24.gap,
                            Text(
                              LocaleKeys.settings_language_subtitle.tr(),
                              style: context.titleLarge.regular.setColor(
                                context.colorScheme.onSurface,
                              ),
                            ),
                            20.gap,
                            ValueListenableBuilder(
                              valueListenable: _selectedLocale,
                              builder: (context, value, child) {
                                return Column(
                                  children: LocalizationConstants
                                      .supportedLocales
                                      .map((locale) {
                                        final isSelected = value == locale;
                                        return _LanguageOptionTile(
                                          title: locale.languageCode == 'ar'
                                              ? 'العربية'
                                              : 'English',
                                          isSelected: isSelected,
                                          onTap: () =>
                                              _selectedLocale.value = locale,
                                        ).paddingBottom(16);
                                      })
                                      .toList(),
                                );
                              },
                            ),
                            8.gap,
                            CustomButton.gradient(
                              isLoading: state.status.isLoading,
                              label: LocaleKeys.actions_confirm.tr(),
                              onPressed: () {
                                if (authState.status.isAuthorized) {
                                  context
                                      .read<LanguageCubit>()
                                      .changeLanguage(
                                        _selectedLocale.value?.languageCode ??
                                            'ar',
                                      );
                                } else {
                                  _onLanguageChanged();
                                }
                              },
                            ),
                            16.gap,
                          ],
                        )
                        .paddingHorizontal(AppSize.screenPadding)
                        .withSafeArea(minimum: 8.edgeInsetsOnlyBottom),
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

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
          children: [
            
            Text(
              title,
              style: context.titleMedium.regular.setColor(
                context.colorScheme.onSurface,
              ),
            ).expand(),
            SizedBox(
              width: 28,
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      color: context.primaryColor,
                      size: 28,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ).paddingHorizontal(16)
        .onTap(onTap, borderRadius: 8.borderRadius)
        .setContainerToView(
          height: 48,
          radius: 8,
          borderColor: isSelected
              ? context.primaryColor
              : context.inputFieldBorderColor,
          color: context.scaffoldBackgroundColor,
        );
       
  }
}
