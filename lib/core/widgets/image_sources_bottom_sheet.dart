import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/media_services.dart';
import 'custom_bottom_sheet.dart';
import 'vertical_list_view.dart';

class ImageSourcesBottomSheet extends StatelessWidget {
  const ImageSourcesBottomSheet({
    super.key,
    this.onImagePicked,
    this.onVideoPicked,
    this.onMediaPicked,
    this.maxFileSize = 2,
    this.maxVideoSize = 5,
  });

  final void Function(XFile?)? onImagePicked;
  final void Function(XFile?)? onVideoPicked;
  final void Function(XFile?)? onMediaPicked;
  final int maxFileSize;
  final int maxVideoSize;

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: LocaleKeys.image_source_upload.tr(),
      child: VerticalListView(
        enableScroll: false,
        padding: 0.edgeInsetsAll,
        separator: const Divider(height: 0, indent: 56),
        itemCount: ImageSource.values.length,
        itemBuilder: (_, index) {
          final source = ImageSource.values[index];
          return Row(
            children: [
              source.icon.svg(height: 24, colorFilter: context.iconColor.colorFilter),
              12.gap,
              Text(source.title, style: context.bodyLarge.s12.regular),
            ],
          ).paddingSymmetric(AppSize.screenPadding, 12).onTap(() async {
            if (onMediaPicked != null && source == ImageSource.gallery) {
              _pickMedia();
              return;
            }
            if (onImagePicked != null) {
              await _pickImage(source);
            }
            if (onVideoPicked != null) {
              _pickVideo(source);
            }
          });
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final context = rootNavigatorKey.currentContext;
    MediaServices.pickImage(source: source).then((image) async {
      if (image != null) {
        context?.pop();
        final size = (await image.length()).bytesToMegaBytes;
        if (size <= maxFileSize) {
          onImagePicked!(image);
        } else {
          Toaster.showToast(LocaleKeys.validator_images_limited_size.tr(args: ["$maxFileSize"]));
        }
      }
    });
  }

  Future<void> _pickVideo(ImageSource source) async {
    final context = rootNavigatorKey.currentContext;
    MediaServices.pickVideo(source: source).then((video) async {
      if (video != null) {
        context?.pop();
        final size = (await video.length()).bytesToMegaBytes;
        if (size <= maxFileSize) {
          onVideoPicked!(video);
        } else {
          Toaster.showToast(LocaleKeys.validator_images_limited_size.tr(args: ["$maxFileSize"]));
        }
      }
    });
  }

  Future<void> _pickMedia() async {
    final context = rootNavigatorKey.currentContext;
    MediaServices.pickMedia().then((media) async {
      if (media != null) {
        context?.pop();
        final size = (await media.length()).bytesToMegaBytes;
        final isImage = media.path.split('.').last.isImage;
        if (size <= (isImage ? maxFileSize : maxVideoSize)) {
          onMediaPicked!(media);
        } else {
          Toaster.showToast(LocaleKeys.validator_images_limited_size.tr(args: ["$maxFileSize"]));
        }
      }
    });
  }
}
