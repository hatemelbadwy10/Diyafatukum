import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/widgets/image_sources_bottom_sheet.dart';

class ProviderStoreImagePicker extends StatefulWidget {
  const ProviderStoreImagePicker({
    super.key,
    required this.initialImagePath,
    required this.onChanged,
  });

  final String initialImagePath;
  final void Function(String imagePath) onChanged;

  @override
  State<ProviderStoreImagePicker> createState() => _ProviderStoreImagePickerState();
}

class _ProviderStoreImagePickerState extends State<ProviderStoreImagePicker> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final imageWidget = _imageFile != null
        ? Image.file(_imageFile!, fit: BoxFit.cover)
        : Image.asset(widget.initialImagePath, fit: BoxFit.cover);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 108,
          height: 108,
          child: imageWidget.clipRRect(54),
        ),
        PositionedDirectional(
          end: -2,
          bottom: -2,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: context.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: context.scaffoldBackgroundColor, width: 3),
            ),
            child: Assets.icons.cameraAddFill.svg(
              width: 18,
              height: 18,
              colorFilter: context.scaffoldBackgroundColor.colorFilter,
            ).center(),
          ).onTap(_pickImage, borderRadius: 17.borderRadius),
        ),
      ],
    );
  }

  void _pickImage() {
    context.showBottomSheet(
      ImageSourcesBottomSheet(
        maxFileSize: 2,
        onImagePicked: (file) {
          if (file == null) return;
          final picked = File(file.path);
          setState(() => _imageFile = picked);
          widget.onChanged(picked.path);
        },
      ),
    );
  }
}
