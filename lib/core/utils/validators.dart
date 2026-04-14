import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config/extensions/all_extensions.dart';
import '../resources/resources.dart';

class Validator {
  static String? validateURL(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      return isRequired ? LocaleKeys.validator_url.tr() : null;
    }
    if (!value.validateURL()) {
      return LocaleKeys.validator_url.tr();
    }
    return null;
  }

  static String? validateEmail(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? LocaleKeys.validator_email.tr() : null;
    }
    if (!value.validateEmail()) {
      return LocaleKeys.validator_email.tr();
    }
    return null;
  }

  static String? validatePhoneSa(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? LocaleKeys.validator_phone.tr() : null;
    }
    if (!value.validateSaPhoneNumber()) {
      return LocaleKeys.validator_phone.tr();
    }
    return null;
  }

  static String? validatePhoneEg(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? LocaleKeys.validator_phone.tr() : null;
    }

    // Remove any spaces or special characters for validation
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it starts with 01 and has 11 digits total
    // OR starts with 1 and has 10 digits total
    bool isValidFormat = false;

    if (cleanValue.startsWith('01') && cleanValue.length == 11) {
      // Format: 01XXXXXXXXX (11 digits)
      // Check if second digit after 01 is valid (0, 1, 2, or 5)
      if (cleanValue.length > 2 && ['0', '1', '2', '5'].contains(cleanValue[2])) {
        isValidFormat = true;
      }
    } else if (cleanValue.startsWith('1') && cleanValue.length == 10) {
      // Format: 1XXXXXXXXX (10 digits)
      // Check if second digit is valid (0, 1, 2, or 5)
      if (cleanValue.length > 1 && ['0', '1', '2', '5'].contains(cleanValue[1])) {
        isValidFormat = true;
      }
    }

    if (!isValidFormat) {
      return LocaleKeys.validator_phone.tr();
    }

    return null;
  }

  static String? validatePhone(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? LocaleKeys.validator_phone.tr() : null;
    }
    if (!value.validatePhone()) {
      return LocaleKeys.validator_phone.tr();
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 8 || value.length > 200) {
      return LocaleKeys.validator_password.tr();
    } else if (!value.validatePassword()) {
      return LocaleKeys.validator_password_pattern.tr();
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty || value != password) {
      return LocaleKeys.validator_confirm_password.tr();
    }
    return null;
  }

  static String? validateName(String? value) {
    final name = value?.trim();
    if (name == null || name.isEmpty || name.replaceAll(" ", "").length < 4) {
      return LocaleKeys.validator_name.tr();
    } else if (!name.validateName() || name.validateSpecialCharacters() || name.isDigit()) {
      return LocaleKeys.validator_name_pattern.tr();
    }
    return null;
  }

  static String? validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validator_filed_required.tr();
    }
    return null;
  }

  static String? validateRequired(String? value, {String? title, bool isRequired = true}) {
    title = title?.toLowerCase().capitalize ?? '';
    if (value == null || value.isEmpty) {
      return isRequired ? LocaleKeys.validator_required.tr(args: [title]) : null;
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty || value.length < 4) {
      return LocaleKeys.validator_otp.tr();
    }
    return null;
  }

  static String? validateImage(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validator_image.tr();
    }
    return null;
  }

  static String? validateFile(File? value, {bool isRequired = true, String? message, String? title, int? maxFileSize}) {
    if (value == null || value.path.isEmpty) {
      return isRequired ? message ?? LocaleKeys.validator_file.tr(args: [title ?? '']) : null;
    } else if (maxFileSize != null && value.lengthSync().bytesToMegaBytes > maxFileSize) {
      return LocaleKeys.validator_file_size.tr(args: [maxFileSize.toString()]);
    }
    return null;
  }

  static String? validatePlatformFile(
    PlatformFile? value, {
    bool isRequired = true,
    String? message,
    int? maxFileSize,
    String? title,
  }) {
    title = title?.toLowerCase() ?? '';
    if (value == null && isRequired) {
      return message ?? LocaleKeys.validator_file.tr(args: [title]);
    }
    if (maxFileSize != null && value != null && value.size.bytesToMegaBytes > maxFileSize) {
      return LocaleKeys.validator_file_size.tr(args: [maxFileSize.toString()]);
    }
    return null;
  }

  static String? validateNumber(
    String? value, {
    bool isRequired = true,
    String? title,
    String? message,
    int? min,
    int? max,
    int? length,
  }) {
    title = title?.toLowerCase().capitalize ?? '';
    if ((value == null || value.isEmpty) && isRequired) {
      return message ?? LocaleKeys.validator_required.tr(args: [title]);
    }
    if (value != null && value.isNotEmpty) {
      if (length != null && value.length != length) {
        return LocaleKeys.validator_digits.tr(args: [title, length.toString()]);
      }
      if (min != null && (value.length) < min) {
        return LocaleKeys.validator_min_digits.tr(args: [title, min.toString()]);
      }
      if (max != null && (value.length) > max) {
        return LocaleKeys.validator_max_digits.tr(args: [title, max.toString()]);
      }
    }
    return null;
  }

  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (endDate == null && startDate == null) {
      return LocaleKeys.validator_required.tr(
        args: [('${LocaleKeys.details_date_time_start.tr()} & ${LocaleKeys.details_date_time_end.tr()}')],
      );
    }
    if (startDate == null) {
      return LocaleKeys.validator_required.tr(args: [(LocaleKeys.details_date_time_start.tr())]);
    }
    if (endDate == null) {
      return LocaleKeys.validator_required.tr(args: [(LocaleKeys.details_date_time_end.tr())]);
    }
    if (startDate.isAfter(endDate)) {
      return LocaleKeys.validator_date_time_start_end.tr();
    }
    return null;
  }

  static String? validateTimeRange(TimeOfDay? startTime, TimeOfDay? endTime) {
    if (endTime == null && startTime == null) {
      return LocaleKeys.validator_required.tr(
        args: [('${LocaleKeys.details_date_time_start_time.tr()} & ${LocaleKeys.details_date_time_end_time.tr()}')],
      );
    }
    if (startTime == null) {
      return LocaleKeys.validator_required.tr(args: [(LocaleKeys.details_date_time_start_time.tr())]);
    }
    if (endTime == null) {
      return LocaleKeys.validator_required.tr(args: [(LocaleKeys.details_date_time_end_time.tr())]);
    }
    return null;
  }

  static String? validateLatLng(LatLng? value, {bool isRequired = true}) {
    if (value == null && isRequired) {
      return LocaleKeys.validator_location.tr();
    }
    return null;
  }
}
