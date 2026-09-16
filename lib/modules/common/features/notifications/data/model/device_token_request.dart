import 'package:equatable/equatable.dart';

class DeviceTokenRequest extends Equatable {
  const DeviceTokenRequest({required this.deviceToken});

  final String deviceToken;

  Map<String, dynamic> toJson() => {'device_token': deviceToken};

  @override
  List<Object> get props => [deviceToken];
}
