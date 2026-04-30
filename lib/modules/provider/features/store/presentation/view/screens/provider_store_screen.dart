import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../controller/provider_store_cubit/provider_store_cubit.dart';
import '../widgets/provider_store_about_section.dart';
import '../widgets/provider_store_about_bottom_sheet.dart';
import '../widgets/provider_store_add_category_chip.dart';
import '../widgets/provider_store_add_category_bottom_sheet.dart';
import '../widgets/provider_store_add_product_bottom_sheet.dart';
import '../widgets/provider_store_category_chip.dart';
import '../widgets/provider_store_edit_bottom_sheet.dart';
import '../widgets/provider_store_empty_state.dart';
import '../widgets/provider_store_header.dart';
import '../widgets/provider_store_product_card.dart';

class ProviderStoreScreen extends StatelessWidget {
  const ProviderStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: BlocBuilder<ProviderStoreCubit, ProviderStoreState>(
        builder: (context, state) {
          final cubit = context.read<ProviderStoreCubit>();

          return state.status.build(
            onLoading: () => const CustomLoading(),
            onFailed: () => CustomFallbackView(
              title: LocaleKeys.error_ops.tr(),
              subtitle: state.status.message,
              buttonLabel: LocaleKeys.actions_retry.tr(),
              onButtonPressed: cubit.loadStore,
            ),
            onSuccess: (_) {
              final store = state.store;
              if (store == null) {
                return const SizedBox.shrink();
              }

              return CustomScrollView(
                slivers: [
                  ProviderStoreHeader(
                    store: store,
                    onEditTap: () => context.showBottomSheet(
                      BlocProvider.value(
                        value: cubit,
                        child: ProviderStoreEditBottomSheet(store: store),
                      ),
                    ),
                  ).toSliver(),
                  ProviderStoreAboutSection(
                    description: store.aboutDescription,
                    highlights: store.aboutHighlights,
                    onTap: () => context.showBottomSheet(
                      BlocProvider.value(
                        value: cubit,
                        child: ProviderStoreAboutBottomSheet(store: store),
                      ),
                    ),
                  ).toSliver(),
                  Container(
                    height: 8,
                    color: context.greySwatch.shade50,
                  ).toSliver(),
                  Column(
                    children: [
                      18.gap,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...store.categories.map(
                              (category) => ProviderStoreCategoryChip(
                                label: category.id == 'all'
                                    ? LocaleKeys.provider_store_categories_all.tr()
                                    : category.name,
                                isSelected: state.selectedCategoryId == category.id,
                                onTap: () => cubit.selectCategory(category.id),
                              ).paddingEnd(10),
                            ),
                            ProviderStoreAddCategoryChip(
                              onTap: () => context.showBottomSheet(
                                BlocProvider.value(
                                  value: cubit,
                                  child: const ProviderStoreAddCategoryBottomSheet(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.isEmpty)
                        ProviderStoreEmptyState(
                          onAddProductTap: () => context.showBottomSheet(
                            BlocProvider.value(
                              value: cubit,
                              child: ProviderStoreAddProductBottomSheet(store: store),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            22.gap,
                            ...state.visibleProducts.map(
                              (product) => ProviderStoreProductCard(
                                product: product,
                                onDeleteTap: () => cubit.deleteProduct(product.id),
                                onEditTap: () => Toaster.showToast(
                                  LocaleKeys.provider_store_edit.tr(),
                                  isError: false,
                                ),
                              ).paddingBottom(18),
                            ),
                            8.gap,
                          ],
                        ),
                      24.gap,
                       if (!state.isEmpty) ...[
                        24.gap,
                        Text(
                              '+ ${LocaleKeys.provider_store_actions_add_product.tr()}',
                              style: context.titleMedium.bold.s18.setColor(context.primaryColor),
                              textAlign: TextAlign.center,
                            )
                            .center()
                            .paddingVertical(18)
                            .setContainerToView(
                              width: double.infinity,
                              alignment: Alignment.center,
                            )
                            .withDottedBorder(color: context.primaryColor, radius: 12)
                            .onTap(
                              () => context.showBottomSheet(
                                BlocProvider.value(
                                  value: cubit,
                                  child: ProviderStoreAddProductBottomSheet(store: store),
                                ),
                              ),
                              borderRadius: 12.borderRadius,
                            )
                            .paddingHorizontal(AppSize.screenPadding),
                      ],

                      32.gap,
                    ],
                  ).toSliver(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
