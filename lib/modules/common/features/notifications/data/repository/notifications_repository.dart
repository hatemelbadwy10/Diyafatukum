import 'package:injectable/injectable.dart';

import '../../../../../../../core/data/error/error_handler.dart';
import '../../../../../../../core/data/models/base_response.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/notifications_remote_datasource.dart';
import '../model/device_token_request.dart';
import '../model/notification_model.dart';

abstract class NotificationsRepository {
  Result<List<NotificationModel>> getNotifications();
  Result markAsRead(String id);
  Result updateSettings(bool enabled);
  Result updateDeviceToken(DeviceTokenRequest request);
}

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  const NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Result<List<NotificationModel>> getNotifications() {
    return remoteDataSource.getNotifications().toResult(notificationsFromJson);
  }

  @override
  Result markAsRead(String id) {
    return remoteDataSource.markAsRead(id).toResult(noDataFromJson);
  }

  @override
  Result updateSettings(bool enabled) async {
    return remoteDataSource
        .updateSettings({'enabled': enabled})
        .toResult(noDataFromJson);
  }

  @override
  Result updateDeviceToken(DeviceTokenRequest request) {
    return remoteDataSource
        .updateDeviceToken(request.toJson())
        .toResult(noDataFromJson);
  }
}
