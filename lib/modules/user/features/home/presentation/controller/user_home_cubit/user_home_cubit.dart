import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../../core/resources/resources.dart';
import '../../../data/model/user_home_model.dart';
import '../../../data/repository/user_home_repository.dart';

part 'user_home_state.dart';

@injectable
class UserHomeCubit extends Cubit<UserHomeState> {
  UserHomeCubit(this._repository) : super(UserHomeState.initial());

  final UserHomeRepository _repository;

  Future<void> getHomeData({String? search}) async {
    final query = search ?? state.searchQuery;
    emit(
      state.copyWith(
        searchQuery: query,
        status: CubitStatus.loading(data: state.status.data),
      ),
    );
    final result = await _repository.getHomeData(search: query);
    result.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(message: failure.message, error: failure))),
      (response) => emit(
        state.copyWith(
          searchQuery: query,
          status: CubitStatus.success(data: response.data),
        ),
      ),
    );
  }

  Future<void> onSearchChanged(String value) async {
    await getHomeData(search: value.trim());
  }
}
