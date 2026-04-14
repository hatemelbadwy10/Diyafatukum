import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../config/extensions/all_extensions.dart';
import '../../resources/resources.dart';
import '../custom_fallback_view.dart';

class CustomPaginatedGridView<T> extends StatelessWidget {
  const CustomPaginatedGridView({
    super.key,
    required this.itemBuilder,
    required this.controller,
    this.onRetry,
    this.padding,
    this.loadingItemBuilder,
    this.emptyItemBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 10,
    this.childAspectRatio = 1,
  });

  final EdgeInsetsGeometry? padding;
  final int crossAxisCount;
  final double crossAxisSpacing, mainAxisSpacing, childAspectRatio;
  final Widget? loadingItemBuilder;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final void Function()? onRetry;
  final Widget Function(BuildContext)? emptyItemBuilder;
  final PagingController<dynamic, T> controller;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? AppSize.screenPadding.edgeInsetsHorizontal,
      sliver: PagingListener(
        controller: controller,
        builder: (context, state, fetchNextPage) {
          return PagedSliverGrid(
            state: state,
            fetchNextPage: fetchNextPage,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
            builderDelegate: PagedChildBuilderDelegate<T>(
              itemBuilder: itemBuilder,
              newPageProgressIndicatorBuilder: (context) => const CupertinoActivityIndicator().center(),
              noItemsFoundIndicatorBuilder:
                  emptyItemBuilder ??
                  (context) => CustomFallbackView(
                    icon: Assets.icons.noSearchResults.svg().paddingBottom(32),
                    title: LocaleKeys.search_not_found.tr(),
                    subtitle: LocaleKeys.search_not_found_subtitle.tr(),
                  ),
              firstPageErrorIndicatorBuilder: (context) => CustomFallbackView(
                icon: Assets.icons.warningFill.svg().paddingBottom(32),
                title: LocaleKeys.error_ops.tr(),
                subtitle: controller.error?.toString(),
                onButtonPressed: onRetry ?? () => controller.refresh(),
              ),
              firstPageProgressIndicatorBuilder: (context) {
                return loadingItemBuilder ?? const CupertinoActivityIndicator().center();
              },
            ),
          );
        },
      ),
    );
  }
}
