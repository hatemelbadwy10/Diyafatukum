import 'package:injectable/injectable.dart';

import '../datasource/notifications_remote_datasource.dart';

abstract class NotificationsRepository {}

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  const NotificationsRepositoryImpl(this.remoteDataSource);
}
