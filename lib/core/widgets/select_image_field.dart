import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/validators.dart';
import 'custom_image.dart';
import 'image_sources_bottom_sheet.dart';

class SelectImageField extends StatefulWidget {
  const SelectImageField({
    super.key,
    this.imageUrl,
    this.validator,
    this.onImageSelected,
    this.isLoading = false,
    this.size = 200,
    this.iconSize = 72,
    this.padding = 65,
    this.uploadPrompt,
  });

  final double size;
  final double iconSize;
  final double padding;
  final String? imageUrl;
  final void Function(File?)? onImageSelected;
  final String? Function(File?)? validator;
  final bool isLoading;
  final Widget? uploadPrompt;

  @override
  State<SelectImageField> createState() => _SelectImageFieldState();
}

class _SelectImageFieldState extends State<SelectImageField> {
  final ValueNotifier<File?> _image = ValueNotifier(null);
  final ValueNotifier<String?> _imageUrl = ValueNotifier(null);

  @override
  void initState() {
    _imageUrl.value = widget.imageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<File>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (widget.validator != null) {
            return widget.validator!(value);
          } else {
            if (_imageUrl.value != null) {
              return null;
            }
            return Validator.validateFile(
              value,
              message: LocaleKeys.validator_image.tr(),
            );
          }
        },
        builder: (FormFieldState<File?> formState) {
          return ValueListenableBuilder(
            valueListenable: _imageUrl,
            builder: (context, url, child) {
              if (url != null && _image.value == null) {
                return CustomImage(
                  imageUrl: url,
                  width: widget.size,
                  height: widget.size,
                  isCircular: true,
                  fit: BoxFit.cover,
                ).onTap(() {
                  if (widget.isLoading) return;
                  _onPhotoPressed(formState);
                }, borderRadius: 100.borderRadius);
              } else {
                return Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _image,
                      builder: (context, File? value, child) {
                        return (value != null
                                ? Image.file(
                                    value,
                                    height: widget.size,
                                    width: widget.size,
                                    fit: BoxFit.cover,
                                  ).clipRRect(1000)
                                : _buildImageUploadPrompt())
                            .animationSwitch();
                      },
                    ).onTap(() {
                      if (widget.isLoading) return;
                      _onPhotoPressed(formState);
                    }, borderRadius: 100.borderRadius),
                    8.gap,
                    if (formState.errorText != null) Text(formState.errorText!, style: context.errorStyle),
                  ],
                );
              }
            },
          );
        });
  }

  Widget _buildImageUploadPrompt() {
    return widget.uploadPrompt ??
        Assets.icons.cameraAddFill
            .svg(height: widget.iconSize, colorFilter: context.iconDisabledColor.colorFilter)
            .setContainerToView(color: context.primaryContainerColor, padding: widget.padding, radius: 1000);
  }

  void _onPhotoPressed(FormFieldState<File?>? formState) {
    context.showBottomSheet(
      ImageSourcesBottomSheet(
        maxFileSize: 2,
        onImagePicked: (xFIle) {
          final image = File(xFIle!.path);
          _image.value = image;
          _imageUrl.value = null;
          widget.onImageSelected?.call(image);
          formState?.didChange(image);
        },
      ),
    );
  }
}
