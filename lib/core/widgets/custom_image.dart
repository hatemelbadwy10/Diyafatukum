import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/extensions/all_extensions.dart';
import '../resources/resources.dart';
import 'shimmer_widget.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.height,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.borderRadius = BorderRadius.zero,
    this.errorWidget,
    this.placeholderWidget,
    this.isCircular = false,
    this.placeholderColor,
    this.enableShimmer = true,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeOutDuration = const Duration(milliseconds: 1000),
  });

  final String imageUrl;
  final double height;
  final double? width;
  final BoxFit fit;
  final bool isCircular;
  final BorderRadiusGeometry borderRadius;
  final Widget? errorWidget;
  final Widget? placeholderWidget;
  final Color? placeholderColor;
  final bool enableShimmer;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final String? cacheKey;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;

  // Convenience constructor for circular images (avatars)
  const CustomImage.avatar({
    super.key,
    required this.imageUrl,
    required double size,
    this.errorWidget,
    this.placeholderWidget,
    this.placeholderColor,
    this.enableShimmer = true,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeOutDuration = const Duration(milliseconds: 1000),
  }) : height = size,
       width = size,
       fit = BoxFit.cover,
       borderRadius = BorderRadius.zero,
       isCircular = true;

  // Convenience constructor for square images
  const CustomImage.square({
    super.key,
    required this.imageUrl,
    required double size,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppSize.mainRadius)),
    this.errorWidget,
    this.placeholderWidget,
    this.placeholderColor,
    this.enableShimmer = true,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeOutDuration = const Duration(milliseconds: 1000),
  }) : height = size,
       width = size,
       isCircular = false;

  // Convenience constructor for rectangular images with rounded corners
  CustomImage.rounded({
    super.key,
    required this.height,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    double radius = AppSize.mainRadius,
    this.errorWidget,
    this.placeholderWidget,
    this.placeholderColor,
    this.enableShimmer = true,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeOutDuration = const Duration(milliseconds: 1000),
  }) : borderRadius = BorderRadius.all(Radius.circular(radius)),
       isCircular = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageWidth = width ?? constraints.maxWidth;
        final imageHeight = height;

        return CachedNetworkImage(
          imageUrl: imageUrl,
          height: imageHeight,
          width: imageWidth,
          fit: fit,
          errorListener: (value) {},
          cacheKey: cacheKey,
          maxWidthDiskCache: maxWidthDiskCache,
          maxHeightDiskCache: maxHeightDiskCache,
          fadeInDuration: fadeInDuration,
          fadeOutDuration: fadeOutDuration,
          placeholder: (context, url) => _buildPlaceholder(context, imageWidth, imageHeight),
          errorWidget: (context, url, error) => _buildErrorWidget(context, imageWidth, imageHeight),
          imageBuilder: (context, imageProvider) => _buildImage(imageProvider, imageWidth, imageHeight),
        );
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context, double imageWidth, double imageHeight) {
    if (placeholderWidget != null) {
      return placeholderWidget!;
    }

    if (isCircular) {
      return ShimmerWidget.circular(
        radius: imageHeight / 2,
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        enableShimmer: enableShimmer,
      );
    }

    return ShimmerSvgIcon(
      size: 40,
      borderRadius: _getBorderRadius(),
      svg: Assets.icons.logo,
      baseColor: shimmerBaseColor ?? context.customColorScheme.greySwatch.shade200,
      highlightColor: shimmerHighlightColor ?? context.customColorScheme.greySwatch.shade300,
      enableShimmer: enableShimmer,
    );
  }

  Widget _buildErrorWidget(BuildContext context, double imageWidth, double imageHeight) {
    final defaultErrorWidget = Container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        borderRadius: isCircular ? null : borderRadius,
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        color: placeholderColor ?? context.customColorScheme.greySwatch[100],
      ),
      child:
          Assets.icons.boxiconsCamera
              .svg(colorFilter: context.customColorScheme.greySwatch[400]?.colorFilter)
              .paddingAll(20)
              .center(),
    );

    return errorWidget ?? defaultErrorWidget;
  }

  Widget _buildImage(ImageProvider imageProvider, double imageWidth, double imageHeight) {
    return Container(
      width: imageWidth,
      height: imageHeight,
      decoration: ShapeDecoration(
        image: DecorationImage(image: imageProvider, fit: fit),
        shape: isCircular ? const CircleBorder() : RoundedRectangleBorder(borderRadius: borderRadius),
      ),
    );
  }

  double _getBorderRadius() {
    if (borderRadius is BorderRadius) {
      final br = borderRadius as BorderRadius;
      return br.topLeft.x;
    }
    return AppSize.mainRadius;
  }
}
