import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/validators.dart';
import 'image_sources_bottom_sheet.dart';

class VideoPickerPrompt extends StatefulWidget {
  const VideoPickerPrompt({
    super.key,
    this.initialVideoUrl,
    this.onPicked,
    this.hint,
    this.title,
    this.validator,
    this.isRequired = true,
    this.maxFileSizeInMB = 5,
    this.onDeleted,
    this.isLoading = false,
  });

  final bool isLoading;
  final String? initialVideoUrl;
  final ValueChanged<File?>? onPicked;
  final String? hint;
  final String? title;
  final String? Function(File?)? validator;
  final bool isRequired;
  final int maxFileSizeInMB;
  final void Function(String)? onDeleted;

  @override
  State<VideoPickerPrompt> createState() => _VideoSelectionPromptState();
}

class _VideoSelectionPromptState extends State<VideoPickerPrompt> {
  final ValueNotifier<String?> _videoUrlNotifier = ValueNotifier(null);
  final ValueNotifier<XFile?> _videoFileNotifier = ValueNotifier(null);

  @override
  void initState() {
    _videoUrlNotifier.value = widget.initialVideoUrl;
    super.initState();
  }

  @override
  void didUpdateWidget(VideoPickerPrompt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialVideoUrl != widget.initialVideoUrl) {
      _videoUrlNotifier.value = widget.initialVideoUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _videoUrlNotifier,
      builder: (context, fileUrl, child) {
        if (fileUrl != null) return _buildNetworkFileDisplay();
        return ValueListenableBuilder(
          valueListenable: _videoFileNotifier,
          builder: (context, file, child) {
            return (file == null ? _buildFileUploadPrompt() : _buildFileDisplay(file));
          },
        );
      },
    );
  }

  Widget _buildFileDisplay(XFile file) {
    return Row(
      children: [
        Assets.icons.docRoundedFill.svg(colorFilter: context.iconColor.colorFilter),
        12.gap,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(file.name, maxLines: 2, overflow: TextOverflow.ellipsis),
            Text(LocaleKeys.size_mb.tr(args: ["${file.size.bytesToMegaBytes}"]), style: context.textTheme.bodySmall),
          ],
        ).expand(),
        12.gap,
        Assets.icons.trash.svg(colorFilter: context.errorColor.colorFilter).paddingAll(8).onTap(() {
          _videoFileNotifier.value = null;
          _videoUrlNotifier.value = null;
          widget.onPicked?.call(null);
        }, borderRadius: 2.borderRadius),
      ],
    ).setContainerToView(borderColor: context.primaryBorder, radius: AppSize.inputBorderRadius, padding: 16);
  }

  Widget _buildFileUploadPrompt() {
    return FormField<File?>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return Validator.validateFile(
          value,
          title: widget.title,
          isRequired: widget.isRequired,
          maxFileSize: widget.maxFileSizeInMB,
        );
      },
      builder: (FormFieldState<File?> formState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Assets.icons.uploadCloud
                        .svg(colorFilter: context.primaryColor.colorFilter, height: 24)
                        .circle(backgroundColor: context.primaryContainerColor),
                    8.gap,
                    if (widget.hint != null) Text(widget.hint!, style: context.textTheme.bodyMedium).paddingBottom(4),
                    Text(LocaleKeys.image_source_click.tr(), style: context.titleLarge.s14.medium),
                  ],
                )
                .center()
                .withDottedBorder(
                  radius: AppSize.inputBorderRadius,
                  padding: 16.edgeInsetsAll,
                  color: formState.hasError ? context.errorColor : context.inputFieldBorderColor,
                )
                .withWidth(double.infinity)
                .onTap(() {
                  _onPressed(formState);
                }, borderRadius: AppSize.inputBorderRadius.borderRadius),
            if (formState.hasError) Text(formState.errorText!, style: context.errorStyle).paddingTop(4).paddingStart(4),
          ],
        );
      },
    );
  }

  Widget _buildNetworkFileDisplay() {
    return Row(
          children: [
            Assets.icons.docRoundedFill.svg(colorFilter: context.iconColor.colorFilter),
            12.gap,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(widget.initialVideoUrl!.split('/').last)],
            ).expand(),
            if (!widget.isLoading)
              const CupertinoActivityIndicator()
            else
              Assets.icons.trash.svg(colorFilter: context.errorColor.colorFilter).paddingAll(8).onTap(() {
                if (widget.onDeleted != null && widget.initialVideoUrl != null) {
                  widget.onDeleted!(widget.initialVideoUrl!);
                } else {
                  _videoUrlNotifier.value = null;
                  _videoFileNotifier.value = null;
                  widget.onPicked?.call(null);
                }
              }, borderRadius: 2.borderRadius),
          ],
        )
        .setContainerToView(borderColor: context.primaryBorder, radius: AppSize.inputBorderRadius, padding: 16)
        .onTap(() async => widget.initialVideoUrl.openUrl(), borderRadius: AppSize.inputBorderRadius.borderRadius);
  }

  void _onPressed(FormFieldState<File?>? formState) {
    context.showBottomSheet(
      ImageSourcesBottomSheet(
        maxFileSize: widget.maxFileSizeInMB,
        onVideoPicked: (video) {
          if (video != null) {
            formState?.didChange(File(video.path));
            if (widget.maxFileSizeInMB < video.size.bytesToMegaBytes) return;
            widget.onPicked?.call(File(video.path));
            _videoFileNotifier.value = video;
            _videoUrlNotifier.value = null;
          }
        },
      ),
    );
  }
}
