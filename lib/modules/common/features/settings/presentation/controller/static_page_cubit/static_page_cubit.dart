import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/static_page_enum.dart';
import '../../../data/repository/settings_repository.dart';

part 'static_page_state.dart';

@injectable
class StaticPageCubit extends Cubit<StaticPageState> {
  final SettingsRepository _repository;
  StaticPageCubit(this._repository) : super(StaticPageState(status: CubitStatus.initial()));

  Future<void> getStaticPageContent(StaticPage type) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.getStaticPageContent(type);
    response.fold(
      (error) => emit(state.copyWith(status: CubitStatus.failed(message: error.message))),
      (content) => emit(state.copyWith(status: CubitStatus.success(data: content))),
    );
  }
}
