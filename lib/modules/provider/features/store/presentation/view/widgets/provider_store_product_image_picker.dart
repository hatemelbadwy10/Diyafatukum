import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/widgets/image_sources_bottom_sheet.dart';

class ProviderStoreProductImagePicker extends StatefulWidget {
  const ProviderStoreProductImagePicker({
    super.key,
    this.initialImagePath,
    required this.onChanged,
  });

  final String? initialImagePath;
  final void Function(String imagePath) onChanged;

  @override
  State<ProviderStoreProductImagePicker> createState() => _ProviderStoreProductImagePickerState();
}

class _ProviderStoreProductImagePickerState extends State<ProviderStoreProductImagePicker> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final preview = widget.initialImagePath != null || _imageFile != null;
    return Row(
      children: [
        if (preview)
          SizedBox(
            width: 94,
            height: 74,
            child: (_imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : Image.asset(widget.initialImagePath!, fit: BoxFit.cover))
                .clipRRect(8),
          ),
        if (preview) 12.gap,
        Expanded(
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.uploadCloud.svg(
                    width: 18,
                    height: 18,
                    colorFilter: context.greySwatch.shade500.colorFilter,
                  ),
                  8.gap,
                  Text(
                    LocaleKeys.provider_store_actions_upload_image.tr(),
                    style: context.bodyMedium.regular.s14.setColor(context.greySwatch.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
              .paddingVertical(16)
              .withDottedBorder(color: context.greySwatch.shade300, radius: 8)
              .onTap(_pickImage, borderRadius: 8.borderRadius),
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
