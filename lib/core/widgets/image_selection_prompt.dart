import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/media_services.dart';
import '../../core/utils/toaster_utils.dart';
import '../../core/utils/validators.dart';
import 'custom_image.dart';
import 'image_sources_bottom_sheet.dart';

class ImageSelectionPrompt extends StatefulWidget {
  const ImageSelectionPrompt({
    super.key,
    this.allowMultiple = true,
    this.initialImagesUrls = const [],
    this.onImagesSelected,
    this.validator,
    this.isLoading = false,
    this.icon,
    this.borderRadius = 8,
    this.maxImages = 5,
    this.height,
    this.width,
    this.crossAxisCount = 3,
    this.onImageDeleted,
    this.title,
    this.isRequired = true,
    this.allowVideos = false,
  });

  final bool isRequired;
  final bool allowMultiple;
  final List<String> initialImagesUrls;
  final ValueChanged<List<File>>? onImagesSelected;
  final String? Function(List<File>)? validator;
  final bool isLoading;
  final Widget? icon;
  final double borderRadius;
  final int maxImages;
  final double? height;
  final double? width;
  final int crossAxisCount;
  final void Function(String)? onImageDeleted;
  final String? title;
  final bool allowVideos;

  factory ImageSelectionPrompt.single({
    Widget? icon,
    double? height,
    double? width,
    String? title,
    bool isLoading = false,
    bool isRequired = true,
    bool allowVideos = false,
    double borderRadius = 8,
    String? initialImageUrl,
    String? Function(File)? validator,
    void Function(String)? onImageDeleted,
    required ValueChanged<File> onImageSelected,
  }) {
    return ImageSelectionPrompt(
      maxImages: 1,
      height: height,
      width: width,
      isRequired: isRequired,
      allowVideos: allowVideos,
      allowMultiple: false,
      title: title,
      borderRadius: borderRadius,
      initialImagesUrls: initialImageUrl != null ? [initialImageUrl] : [],
      onImageDeleted: onImageDeleted,
      onImagesSelected: (images) {
        if (images.isNotEmpty) {
          onImageSelected(images.first);
        }
      },
      validator: (images) {
        if (images.isNotEmpty) {
          return validator?.call(images.first);
        }
        return null;
      },
      isLoading: isLoading,
      icon: icon,
    );
  }

  @override
  State<ImageSelectionPrompt> createState() => _ImageSelectionPromptState();
}

class _ImageSelectionPromptState extends State<ImageSelectionPrompt> {
  final ValueNotifier<List<File>> _images = ValueNotifier([]);
  final ValueNotifier<List<String>> _imagesUrls = ValueNotifier([]);

  late double _width;

  @override
  void initState() {
    _imagesUrls.value = widget.initialImagesUrls;
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = context.width - (2 * AppSize.screenPadding);
    _width = (screenWidth / widget.crossAxisCount) - 16;
  }

  @override
  void didUpdateWidget(ImageSelectionPrompt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allowMultiple == true && oldWidget.initialImagesUrls != widget.initialImagesUrls) {
      _imagesUrls.value = widget.initialImagesUrls;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _imagesUrls,
      builder: (context, urls, child) {
        return ValueListenableBuilder(
            valueListenable: _images,
            builder: (context, files, child) {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (urls.isNotEmpty) ...urls.map((url) => _buildNetworkImage(url)),
                  if (files.isNotEmpty) ...files.map((file) => _buildFileImage(file)),
                  if ((files.length + urls.length) < widget.maxImages) _buildAddImageField()
                ],
              );
            });
      },
    ).setTitle(
        title: widget.title,
        titleStyle: context.bodyMedium.s12.regular,
        titleIcon: widget.isLoading ? const CupertinoActivityIndicator(radius: 8) : null);
  }

  Widget _buildNetworkImage(String url) {
    return Stack(
      children: [
        CustomImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: widget.height ?? _width,
          height: widget.width ?? _width,
        ).clipRRect(widget.borderRadius - 4).withDottedBorder(
              padding: 4.edgeInsetsAll,
              radius: widget.borderRadius,
              color: context.iconInactiveColor,
            ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          top: 0,
          end: 0,
          child: _buildDeleteButton(() {
            if (widget.isLoading) return;
            if (widget.onImageDeleted != null) {
              widget.onImageDeleted?.call(url);
            } else {
              final List<String> images = List.from(_imagesUrls.value);
              images.remove(url);
              _imagesUrls.value = images;
            }
          }),
        ),
      ],
    );
  }

  Widget _buildFileImage(File file) {
    final bool isImage = file.path.isImage;
    return Stack(
      children: [
        (isImage
                ? Image.file(
                    file,
                    width: widget.height ?? _width,
                    height: widget.width ?? _width,
                    fit: BoxFit.cover,
                  )
                : SizedBox(
                    width: widget.height ?? _width,
                    height: widget.width ?? _width,
                    child: VideoPlayerThumbnail(videoFile: file),
                  ))
            .clipRRect(widget.borderRadius - 4)
            .withDottedBorder(
              padding: 4.edgeInsetsAll,
              radius: widget.borderRadius,
              color: context.iconInactiveColor,
            ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          top: 0,
          end: 0,
          child: _buildDeleteButton(() {
            final List<File> images = List.from(_images.value);
            images.remove(file);
            _images.value = images;
            widget.onImagesSelected?.call(_images.value);
          }),
        ),
      ],
    );
  }

  Widget _buildAddImageField() {
    return FormField<File?>(
      validator: (value) => Validator.validateFile(
        value,
        message: LocaleKeys.validator_image.tr(),
        isRequired: widget.isRequired,
      ),
      builder: (FormFieldState formState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.icon ??
                Assets.icons.plus
                    .svg(height: 32, colorFilter: context.iconInactiveColor.colorFilter)
                    .center()
                    .withDottedBorder(
                      padding: 4.edgeInsetsAll,
                      radius: widget.borderRadius,
                      color: formState.hasError ? context.errorColor : context.iconInactiveColor,
                    )
                    .withSize((widget.width ?? _width) + 8, (widget.height ?? _width) + 8)
                    .onTap(() async {
                  if (widget.isLoading) return;
                  if (widget.allowMultiple) {
                    _onMultipleSelection();
                  } else {
                    onSingleSelection(formState);
                  }
                }, borderRadius: widget.borderRadius.borderRadius),
            if (formState.hasError) Text(formState.errorText!, style: context.errorStyle).paddingTop(4),
          ],
        );
      },
    );
  }

  Widget _buildDeleteButton(void Function() onDelete) {
    return Assets.icons.trash
        .svg(height: 16, colorFilter: context.errorColor.colorFilter)
        .setContainerToView(color: context.scaffoldBackgroundColor, padding: 4, radius: 1000)
        .onTap(onDelete, borderRadius: 1000.borderRadius)
        .paddingAll(8);
  }

  void _onMultipleSelection() async {
    final maxImagesCount = widget.maxImages;
    final imagesLength = _images.value.length;
    final images = await MediaServices.pickMultipleImages(maxImages: maxImagesCount - imagesLength);
    List<XFile> validImages = [];
    for (final image in images) {
      final size = (await image.length()).bytesToMegaBytes;
      if (size <= 2) {
        validImages.add(image);
      } else {
        Toaster.showToast(LocaleKeys.validator_images_limited_size.tr(args: ["2"]));
      }
    }
    if (validImages.isEmpty) return;
    _images.value = [..._images.value, ...validImages.map((e) => File(e.path))];
    widget.onImagesSelected?.call(_images.value);
  }

  void onSingleSelection(FormFieldState formState) async {
    context.showBottomSheet(ImageSourcesBottomSheet(
      onMediaPicked: widget.allowVideos
          ? (xFile) {
              if (xFile == null) return;
              final video = File(xFile.path);
              _images.value = [..._images.value, video];
              formState.didChange(video);
              widget.onImagesSelected?.call(_images.value);
            }
          : null,
      onImagePicked: (xFile) {
        if (xFile == null) return;
        final image = File(xFile.path);
        _images.value = [..._images.value, image];
        formState.didChange(image);
        widget.onImagesSelected?.call(_images.value);
      },
    ));
  }
}

class VideoPlayerThumbnail extends StatelessWidget {
  const VideoPlayerThumbnail({super.key, required this.videoFile});
  final File videoFile;

  Future<Uint8List> _getThumbnail() async {
    return await VideoThumbnail.thumbnailData(
      video: videoFile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getThumbnail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        }
        if (snapshot.hasError) {
          return const Text('Error');
        }
        return Image.memory(snapshot.data as Uint8List, fit: BoxFit.cover);
      },
    );
  }
}
