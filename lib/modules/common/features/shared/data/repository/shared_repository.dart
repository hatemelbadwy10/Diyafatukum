import 'package:injectable/injectable.dart';

abstract class SharedRepository {}

@LazySingleton(as: SharedRepository)
class SharedRepositoryImpl implements SharedRepository {
  const SharedRepositoryImpl();
}
