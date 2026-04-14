import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../resources/resources.dart';
import '../router/route_manager.dart';
import '../theme/light_theme.dart' show LightThemeColors;

extension DateTimeExtensions on DateTime? {
  DateTime get validate {
    if (this == null) {
      return DateTime.now();
    }
    return this!;
  }

  String format({String format = 'dd/MM/yyyy', bool enableLocalization = true}) {
    final locale = rootNavigatorKey.currentContext!.locale.toString();
    return DateFormat(format, enableLocalization ? locale : null).format(validate);
  }

  String formatTime({String format = 'hh:mm a'}) {
    final locale = rootNavigatorKey.currentContext!.locale.toString();
    return DateFormat(format, locale).format(validate);
  }

  bool get isNull => this == null;

  DateTime get startOfDay => DateTime(validate.year, validate.month, validate.day, 0, 0, 0, 0);

  DateTime get endOfDay => DateTime(validate.year, validate.month, validate.day, 23, 59, 59, 999);

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(hour: validate.hour, minute: validate.minute);
  }

  /// Returns Good Morning, Good Evening based on the time of day.
  /// If the time is before 12 PM, it returns Good Morning.
  /// If the time is between 12 PM and 6 PM, it returns Good Afternoon
  String get timeGreetingText {
    final hour = validate.hour;
    if (hour < 12) {
      return LocaleKeys.home_welcome_good_morning.tr();
    } else if (hour < 18) {
      return LocaleKeys.home_welcome_good_afternoon.tr();
    } else {
      return LocaleKeys.home_welcome_good_evening.tr();
    }
  }

  // SvgGenImage get greetingIcon {
  //   final hour = validate.hour;
  //   if (hour < 12) {
  //     return Assets.icons.sun;
  //   } else if (hour < 18) {
  //     return Assets.icons.moonEclipse;
  //   } else {
  //     return Assets.icons.moonEclipse;
  //   }
  // }

  Color get greetingColor {
    final hour = validate.hour;
    if (hour < 12) {
      return LightThemeColors.accent;
    } else if (hour < 18) {
      return LightThemeColors.grey[200]!;
    } else {
      return LightThemeColors.grey[200]!;
    }
  }
}

extension DurationExtensions on Duration {
  String get formatDuration {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(inMinutes.remainder(60));
    final seconds = twoDigits(inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

extension TimeOfDayExtensions on TimeOfDay? {
  TimeOfDay get validate {
    if (this == null) {
      return TimeOfDay.now();
    }
    return this!;
  }

  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, validate.minute, validate.minute);
  }

  String formatTime({String format = 'hh:mm a'}) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, validate.hour, validate.minute);
    return dateTime.formatTime(format: format);
  }

  bool isAfter(TimeOfDay time) {
    return validate.hour > time.hour || (validate.hour == time.hour && validate.minute > time.minute);
  }
}
