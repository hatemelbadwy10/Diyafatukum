import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../../core/resources/resources.dart';
import '../../../../home/data/model/user_home_model.dart';
import '../../../data/model/single_service_model.dart';
import '../../../data/repository/single_service_repository.dart';

part 'single_service_state.dart';

@injectable
class SingleServiceCubit extends Cubit<SingleServiceState> {
  SingleServiceCubit(this._repository) : super(SingleServiceState.initial()) {
    pagingController = PagingController<int, SingleServiceProductModel>(
      getNextPageKey: (pagingState) {
        final lastPageKey = pagingState.keys?.isNotEmpty == true
            ? pagingState.keys!.last
            : 0;
        if (lastPageKey >= _lastPage) return null;
        return lastPageKey + 1;
      },
      fetchPage: _fetchPage,
    );
  }

  final SingleServiceRepository _repository;
  late final PagingController<int, SingleServiceProductModel> pagingController;

  late UserHomeServiceModel _service;
  int _lastPage = 1;

  void initialize(UserHomeServiceModel service) {
    _service = service;
    emit(
      state.copyWith(
        status: CubitStatus.success(data: service.titleKey),
        service: service,
      ),
    );
    pagingController.refresh();
  }

  Future<List<SingleServiceProductModel>> _fetchPage(int pageKey) async {
    if (pageKey == 1) {
      emit(state.copyWith(status: CubitStatus.loading(data: state.status.data)));
    }
    final result = await _repository.getService(_service.iconKey, {
      'page': pageKey.toString(),
    });

    return result.fold((failure) {
      if (pageKey == 1) {
        emit(
          state.copyWith(
            status: CubitStatus.failed(
              message: failure.message,
              error: failure,
            ),
          ),
        );
      }
      throw Exception(failure.message);
    }, (response) {
      final serviceData = response.data;
      if (serviceData == null) {
        throw Exception(response.message ?? '');
      }
      _lastPage = serviceData.lastPage;
      if (pageKey == 1) {
        emit(
          state.copyWith(
            status: CubitStatus.success(data: serviceData.titleKey),
          ),
        );
      }
      return serviceData.products;
    });
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
