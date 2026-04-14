import 'package:dio/dio.dart';

enum VerificationType {
  register,
  forgetPassword,
  changePhone,
  changeEmail;

  Future<Response> verify({
    Future<Response> Function()? onRegister,
    Future<Response> Function()? onForgetPassword,
    Future<Response> Function()? onChangePhone,
    Future<Response> Function()? onChangeEmail,
  }) async {
    switch (this) {
      case VerificationType.register:
        return onRegister != null ? onRegister.call() : Future.error('onRegister callback is null');
      case VerificationType.forgetPassword:
        return onForgetPassword != null ? onForgetPassword.call() : Future.error('onForgetPassword callback is null');
      case VerificationType.changePhone:
        return onChangePhone != null ? onChangePhone.call() : Future.error('onChangePhone callback is null');
      case VerificationType.changeEmail:
        return onChangeEmail != null ? onChangeEmail.call() : Future.error('onChangeEmail callback is null');
    }
  }

  void onVerified({
    void Function()? onRegister,
    void Function()? onForgetPassword,
    void Function()? onChangePhone,
    void Function()? onChangeEmail,
  }) {
    switch (this) {
      case VerificationType.register:
        onRegister?.call();
        break;
      case VerificationType.forgetPassword:
        onForgetPassword?.call();
        break;
      case VerificationType.changePhone:
        onChangePhone?.call();
        break;
      case VerificationType.changeEmail:
        onChangeEmail?.call();
        break;
    }
  }
}
