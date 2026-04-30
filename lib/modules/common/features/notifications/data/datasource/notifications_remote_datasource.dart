import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';
import '../../../../../../../core/resources/type_defs.dart';
import 'package:dio/dio.dart';

abstract class NotificationsRemoteDataSource {
  Future<Response> updateSettings(BodyMap body);
}

@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final ApiClient client;
  const NotificationsRemoteDataSourceImpl(this.client);

  @override
  Future<Response> updateSettings(BodyMap body) async =>
      client.put(RemoteUrls.notificationSettings, data: body);
}
