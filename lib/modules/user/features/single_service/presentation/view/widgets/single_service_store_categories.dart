import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/single_service_store_model.dart';

class SingleServiceStoreCategories extends StatelessWidget {
  const SingleServiceStoreCategories({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<SingleServiceStoreCategoryModel> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSize.screenPadding),
        itemCount: categories.length,
        separatorBuilder: (_, _) => 12.gap,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedCategoryId;
          return Text(
                category.name,
                style: context.titleSmall.medium.s16.setColor(
                  isSelected
                      ? context.onPrimary
                      : (context.titleMedium.color ??
                            context.colorScheme.onSurface),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
              .center()
              .paddingSymmetric(18, 12)
              .setContainerToView(
                radius: 14,
                color: isSelected
                    ? context.primaryColor
                    : context.scaffoldBackgroundColor,
                borderColor: isSelected
                    ? context.primaryColor
                    : context.greySwatch.shade300,
              )
              .onTap(
                () => onCategorySelected(category.id),
                borderRadius: 14.borderRadius,
              );
        },
      ),
    );
  }
}
