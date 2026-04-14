import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../config/extensions/all_extensions.dart';
import '../../resources/resources.dart';
import '../custom_fallback_view.dart';

class PaginatedListView<P, T> extends StatelessWidget {
  const PaginatedListView({
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
    this.separator,
    this.loadingItemBuilder,
    this.emptyItemBuilder,
    this.scrollDirection = Axis.vertical,
  });

  final double height;
  final bool enableScroll;
  final double separatorHeight;
  final Widget? separator;
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
    return SizedBox(
      height: scrollDirection == Axis.horizontal ? height : null,
      child: RefreshIndicator.adaptive(
        onRefresh: () async => controller.refresh(),
        child: PagingListener(
          controller: controller,
          builder: (context, state, fetchNextPage) {
            return PagedListView<P, T>.separated(
              state: state,
              shrinkWrap: true,
              fetchNextPage: fetchNextPage,
              scrollDirection: scrollDirection,
              physics: BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: padding ?? EdgeInsets.symmetric(horizontal: AppSize.screenPadding),
              separatorBuilder: (_, _) => separator ?? SizedBox(height: separatorHeight, width: separatorHeight),
              builderDelegate: PagedChildBuilderDelegate<T>(
                itemBuilder: itemBuilder,
                newPageProgressIndicatorBuilder: (context) => const CupertinoActivityIndicator().center(),
                noItemsFoundIndicatorBuilder: emptyItemBuilder ??
                    (context) => CustomFallbackView(
                          icon: Assets.icons.noSearchResults.svg().paddingBottom(32),
                          title: LocaleKeys.search_not_found.tr(),
                          subtitle: LocaleKeys.search_not_found_subtitle.tr(),
                        ),
                firstPageErrorIndicatorBuilder: (context) => CustomFallbackView(
                  padding: 24,
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: context.errorColor,
                      shape: ContinuousRectangleBorder(borderRadius: 24.borderRadius),
                    ),
                    child: Assets.icons.error.svg(height: 32),
                  ),
                  title: LocaleKeys.error_ops.tr(),
                  subtitle: controller.error?.toString(),
                  onButtonPressed: onRetry ?? () => controller.refresh(),
                ).paddingTop(context.height * 0.15),
                firstPageProgressIndicatorBuilder: (context) {
                  return loadingItemBuilder ?? const CupertinoActivityIndicator().center();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
