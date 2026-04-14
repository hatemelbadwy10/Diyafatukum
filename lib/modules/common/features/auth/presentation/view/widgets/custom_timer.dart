import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';

class CustomTimer extends StatefulWidget {
  const CustomTimer({
    super.key,
    this.onRestart,
    this.isLoading = false,
    this.timerSeconds = AppConstants.otpTimerDuration,
  });

  final bool isLoading;
  final int timerSeconds;
  final Function()? onRestart;

  @override
  State<CustomTimer> createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  late int _timerSeconds;
  late bool _isTimerActive = true;

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timerSeconds > 0) {
            _timerSeconds--;
          } else {
            _isTimerActive = false;
            timer.cancel();
          }
        });
      }
    });
  }

  void _restartTimer() {
    setState(() {
      _timerSeconds = widget.timerSeconds;
      _isTimerActive = true;
    });
    _startTimer();
  }

  @override
  void initState() {
    _timerSeconds = widget.timerSeconds;
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isTimerActive ? '${LocaleKeys.auth_otp_timer.tr()}:' : LocaleKeys.auth_otp_resend_hint.tr(),
          textAlign: TextAlign.center,
          style: context.titleLarge.regular.s13,
        ),
        widget.isLoading
            ? const CupertinoActivityIndicator().paddingHorizontal(8).flexible()
            : CustomTextButton(
                label: _isTimerActive ? _timerSeconds.seconds.formatDuration : LocaleKeys.auth_otp_resend.tr(),
                textStyle: context.displaySmall.s13.regular,
                onPressed: () {
                  if (!_isTimerActive) {
                    _restartTimer();
                    widget.onRestart?.call();
                  }
                },
              ),
      ],
    );
  }
}
