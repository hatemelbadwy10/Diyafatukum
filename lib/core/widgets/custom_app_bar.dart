import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/config/router/route_manager.dart';
import '../resources/resources.dart';
import 'custom_arrow_back.dart';
import 'custom_search_field.dart';

class CustomAppBar {
  static PreferredSize build({
    Key? key,
    String? titleText,
    TextStyle? titleStyle,
    Widget? title,
    Widget? leading,
    double leadingWidth = 52,
    List<Widget>? actions,
    bool? removeBack,
    bool centerTitle = true,
    Color? backgroundColor,
    Color? iconColor,
    Widget? bottom,
    double bottomHeight = 40,
    double height = kToolbarHeight,
    bool showBackground = false,
    SystemUiOverlayStyle? systemOverlayStyle,
    void Function()? onLeadingPressed,
  }) {
    final context = rootNavigatorKey.currentContext!;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return PreferredSize(
      key: key,
      preferredSize: Size.fromHeight(height),
      child: Stack(
        children: [
          if (showBackground) ...[
            Positioned.fill(child: Container(alignment: Alignment.topCenter, color: context.secondaryColor)),
            Positioned(top: 0, left: 0, right: 0, child: Assets.images.appBarOverlay.image(fit: BoxFit.cover)),
          ],
          AppBar(
            titleSpacing: 16,
            actions: actions,
            actionsPadding: const EdgeInsetsDirectional.only(end: 16),
            toolbarHeight: height,
            leadingWidth: leadingWidth,
            centerTitle: centerTitle,
            titleTextStyle: titleStyle??context.titleSmall.bold.s18,
            backgroundColor: backgroundColor ?? Colors.transparent,
            title: title ?? Text(titleText ?? '', style: titleStyle),
            iconTheme: context.iconTheme?.copyWith(color: iconColor),
            automaticallyImplyLeading: removeBack == true ? false : true,
            systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.light,
            leading: _getLeading(context, leading: leading, removeBack: removeBack, onLeadingPressed: onLeadingPressed),
            bottom: bottom != null ? PreferredSize(preferredSize: Size.fromHeight(bottomHeight), child: bottom) : null,
          ),
        ],
      ),
    );
  }

  static AppBar search(
    BuildContext context, {
    void Function(String)? onChanged,
    Widget? bottom,
    String? hintText,
    double bottomHeight = 40,
    void Function()? onFilter,
  }) {
    return AppBar(
      toolbarHeight: 90,
      title: CustomSearchField(onChanged: onChanged, hintText: hintText, onFilter: onFilter),
      bottom: bottom != null ? PreferredSize(preferredSize: Size.fromHeight(bottomHeight), child: bottom) : null,
    );
  }

  static Widget? _getLeading(
    BuildContext context, {
    Widget? leading,
    bool? removeBack,
    void Function()? onLeadingPressed,
  }) {
    if (leading != null) {
      return leading;
    } else {
      if (removeBack == true || !context.canPopScreen) {
        return null;
      } else {
        return Align(alignment: AlignmentDirectional.centerEnd, child: CustomArrowBack(onPressed: onLeadingPressed));
      }
    }
  }
}
