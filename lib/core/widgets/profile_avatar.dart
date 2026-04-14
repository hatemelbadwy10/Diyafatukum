import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import 'buttons/custom_icon_button.dart';
import 'custom_image.dart';
import 'image_sources_bottom_sheet.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.size = 100,
    this.onChanged,
    this.name,
    this.nameStyle,
    this.onTap,
  });

  final String? name;
  final String? imageUrl;
  final double size;
  final void Function(File)? onChanged;
  final TextStyle? nameStyle;
  final void Function()? onTap;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  final ValueNotifier<File?> _avatarNotifier = ValueNotifier<File?>(null);

  @override
  void initState() {
    _avatarNotifier.addListener(() {
      if (_avatarNotifier.value != null) {
        widget.onChanged?.call(_avatarNotifier.value!);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _avatarNotifier,
      builder: (_, _, _) {
        return Stack(
          children: [
            if (!widget.name.isEmptyOrNull && widget.imageUrl.isEmptyOrNull && _avatarNotifier.value == null)
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(shape: BoxShape.circle, color: context.primaryContainerColor),
                child: Text(
                  widget.name!.getInitialsOfName(),
                  style: widget.nameStyle ?? context.titleLarge.bold.s24,
                ).center(),
              ).onTap(() => widget.onTap?.call(), isTransparent: true)
            else if (_avatarNotifier.value != null)
              Image.file(
                _avatarNotifier.value!,
                height: widget.size,
                width: widget.size,
                fit: BoxFit.cover,
              ).clipRRect(100)
            else if (!widget.imageUrl.isNull)
              CustomImage(
                height: widget.size,
                width: widget.size,
                isCircular: true,
                fit: BoxFit.cover,
                imageUrl: widget.imageUrl!,
              ),
            if (widget.onChanged != null)
              Positioned.directional(
                end: 0,
                bottom: 0,
                textDirection: Directionality.of(context),
                child: CustomIconButton.svg(
                  size: 20,
                  svg: Assets.icons.cameraAddFill,
                  foregroundColor: context.primaryColor,
                  onPressed: () {
                    context.showBottomSheet(
                      ImageSourcesBottomSheet(
                        onImagePicked: (xFile) {
                          if (xFile == null) return;
                          _avatarNotifier.value = File(xFile.path);
                        },
                      ),
                    );
                  },
                ).circle(radius: 16, backgroundColor: context.surfaceColor),
              ),
          ],
        ).onTap(
          widget.onChanged != null
              ? () {
                  context.showBottomSheet(
                    ImageSourcesBottomSheet(
                      onImagePicked: (xFile) {
                        if (xFile == null) return;
                        _avatarNotifier.value = File(xFile.path);
                      },
                    ),
                  );
                }
              : null,
          borderRadius: 100.borderRadius,
        );
      },
    );
  }
}
