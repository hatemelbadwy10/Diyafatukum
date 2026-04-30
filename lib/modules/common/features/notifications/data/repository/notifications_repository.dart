import 'package:injectable/injectable.dart';

import '../../../../../../../core/data/error/error_handler.dart';
import '../../../../../../../core/data/models/base_response.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/notifications_remote_datasource.dart';

abstract class NotificationsRepository {
  Result updateSettings(bool enabled);
}

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  const NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Result updateSettings(bool enabled) async {
    return remoteDataSource
        .updateSettings({'enabled': enabled})
        .toResult(noDataFromJson);
  }
}
