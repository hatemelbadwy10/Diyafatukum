import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../config/extensions/all_extensions.dart';
import '../../resources/resources.dart';
import '../custom_fallback_view.dart';

class PaginatedSliverListView<P, T> extends StatelessWidget {
  const PaginatedSliverListView({
    super.key,
    required this.itemBuilder,
    required this.controller,
    this.onRetry,
    this.padding,
    this.title,
    this.titleStyle,
    this.enableScroll = true,
    this.height = 120,
    this.separatorHeight = 16,
    this.loadingItemBuilder,
    this.emptyItemBuilder,
    this.scrollDirection = Axis.vertical,
  });

  final double height;
  final bool enableScroll;
  final double separatorHeight;
  final String? title;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Widget? loadingItemBuilder;
  final Widget Function(BuildContext)? emptyItemBuilder;
  final PagingController<P, T> controller;
  final void Function()? onRetry;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: AppSize.screenPadding),
      sliver: PagingListener(
        controller: controller,
        builder: (context, state, fetchNextPage) {
          return PagedSliverList<P, T>.separated(
            state: state,
            fetchNextPage: fetchNextPage,
            separatorBuilder: (_, _) => SizedBox(height: separatorHeight, width: separatorHeight),
            builderDelegate: PagedChildBuilderDelegate<T>(
              itemBuilder: itemBuilder,
              noItemsFoundIndicatorBuilder: emptyItemBuilder ??
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
      ),
    );
  }
}
