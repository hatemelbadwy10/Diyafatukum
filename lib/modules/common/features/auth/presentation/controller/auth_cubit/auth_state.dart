part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unauthorized, this.message = '', this.auth = const AuthModel.guest()});

  final AuthStatus status;
  final AuthModel auth;
  final String message;

  UserModel get user => auth.user;
  AddressModel? get address => user.address;

  AuthState copyWith({AuthStatus? status, String? message, AuthModel? auth, CubitStatus? registerStatus}) {
    return AuthState(status: status ?? this.status, message: message ?? this.message, auth: auth ?? this.auth);
  }

  @override
  List<Object> get props => [status, message, auth];
}
