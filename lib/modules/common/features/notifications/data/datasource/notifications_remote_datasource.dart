import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';

abstract class NotificationsRemoteDataSource {}

@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final ApiClient client;
  const NotificationsRemoteDataSourceImpl(this.client);
}
