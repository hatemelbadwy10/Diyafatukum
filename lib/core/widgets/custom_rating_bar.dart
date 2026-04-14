import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({
    super.key,
    this.itemSize = 10,
    this.initialRating,
    this.itemCount = 5,
    this.itemPadding,
    this.onRatingUpdate,
    this.activeColor,
    this.inactiveColor,
    this.allowHalfRating = true,
  });
  final double itemSize;
  final num? initialRating;
  final int itemCount;
  final EdgeInsetsGeometry? itemPadding;
  final void Function(double)? onRatingUpdate;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool allowHalfRating;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      itemSize: itemSize,
      initialRating: initialRating?.toDouble() ?? 0.0,
      direction: Axis.horizontal,
      allowHalfRating: allowHalfRating,
      itemCount: itemCount,
      minRating: 1,
      ignoreGestures: onRatingUpdate == null,
      itemPadding: itemPadding ?? 4.edgeInsetsOnlyEnd,
      onRatingUpdate: onRatingUpdate ?? (rating) {},
      ratingWidget: RatingWidget(
        full: Assets.icons.starFill.svg(
          width: itemSize,
          colorFilter: (activeColor ?? context.warningColor).colorFilter,
        ),
        half: Assets.icons.starHalf.svg(
          width: itemSize,
          colorFilter: (activeColor ?? context.warningColor).colorFilter,
        ),
        empty: Assets.icons.star.svg(width: itemSize, colorFilter: (inactiveColor ?? context.iconColor).colorFilter),
      ),
    );
  }
}
