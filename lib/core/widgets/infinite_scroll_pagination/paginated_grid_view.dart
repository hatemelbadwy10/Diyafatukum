import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../config/extensions/all_extensions.dart';
import '../../resources/resources.dart';
import '../custom_fallback_view.dart';

class PaginatedGridView<P, T> extends StatelessWidget {
  const PaginatedGridView({
    super.key,
    required this.itemBuilder,
    required this.controller,
    this.onRetry,
    this.padding,
    this.loadingItemBuilder,
    this.emptyItemBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 20,
    this.mainAxisSpacing = 16,
    this.childAspectRatio = 1,
    this.gridDelegate,
  });

  final SliverGridDelegate? gridDelegate;
  final EdgeInsetsGeometry? padding;
  final int crossAxisCount;
  final double crossAxisSpacing, mainAxisSpacing, childAspectRatio;
  final Widget? loadingItemBuilder;
  final void Function()? onRetry;
  final Widget Function(BuildContext)? emptyItemBuilder;
  final PagingController<P, T> controller;
  final Widget Function(BuildContext, T, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return PagingListener(
      controller: controller,
      builder: (context, state, fetchNextPage) {
        return PagedGridView<P, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          padding: padding,
          gridDelegate:
              gridDelegate ??
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
                childAspectRatio: childAspectRatio,
              ),
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: itemBuilder,
            noItemsFoundIndicatorBuilder:
                emptyItemBuilder ??
                (context) => CustomFallbackView(
                  icon: Assets.icons.noSearchResults.svg().paddingBottom(32),
                  title: LocaleKeys.search_not_found.tr(),
                  subtitle: LocaleKeys.search_not_found_subtitle.tr(),
                ),
            newPageProgressIndicatorBuilder: (context) => const CupertinoActivityIndicator().center(),
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
    );
  }
}
