import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';

abstract class SharedRemoteDatasource {}

@LazySingleton(as: SharedRemoteDatasource)
class SharedRemoteDatasourceImpl implements SharedRemoteDatasource {
  final ApiClient client;
  const SharedRemoteDatasourceImpl(this.client);
}
