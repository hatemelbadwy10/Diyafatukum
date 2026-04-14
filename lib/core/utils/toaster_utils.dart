import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../resources/enums/toast_type_enum.dart';
import '../widgets/custom_toast.dart';

class Toaster {
  Toaster._();

  static void showToast(String text, {bool isError = true}) {
    BotToast.cleanAll();
    BotToast.showCustomText(
      duration: const Duration(seconds: 3),
      toastBuilder: (cancelFunc) => CustomToast(
        type: isError ? ToastType.error : ToastType.success,
        text: text,
        onDismiss: () => cancelFunc(), // Pass the cancel function
      ),
    );
  }

  static void success(String text, {bool isPersistent = false}) {
    BotToast.cleanAll();
    BotToast.showCustomText(
      clickClose: true,
      ignoreContentClick: false,
      crossPage: false,
      duration: isPersistent ? null : const Duration(seconds: 3),
      toastBuilder: (cancelFunc) => CustomToast(type: ToastType.success, text: text, onDismiss: cancelFunc),
    );
  }

  static void failure(String text, {bool isPersistent = false}) {
    BotToast.cleanAll();
    BotToast.showCustomText(
      clickClose: true,
      ignoreContentClick: false,
      crossPage: false,
      duration: isPersistent ? null : const Duration(seconds: 3),
      toastBuilder: (cancelFunc) => CustomToast(type: ToastType.error, text: text, onDismiss: cancelFunc),
    );
  }

  static void warning(String text, {bool isPersistent = false}) {
    if (!isPersistent) BotToast.cleanAll();
    BotToast.showCustomText(
      duration: isPersistent ? null : const Duration(seconds: 3),
      clickClose: true,
      ignoreContentClick: false,
      crossPage: false,
      toastBuilder: (cancelFunc) => CustomToast(type: ToastType.warning, text: text, onDismiss: cancelFunc),
    );
  }

  static void closePersistentToast() {
    BotToast.cleanAll();
  }

  // Other methods remain the same
  static void showLoading() {
    BotToast.showCustomLoading(
      toastBuilder: (cancelFunc) {
        return const Card(
          color: Colors.white,
          child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
        );
      },
    );
  }

  static void closeLoading() {
    BotToast.closeAllLoading();
  }
}
