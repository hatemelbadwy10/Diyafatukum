import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../../core/resources/type_defs.dart';

import 'package:injectable/injectable.dart';

import '../../../../../../../../core/resources/resources.dart';
import '../../../data/model/user_model.dart';
import '../../../data/repository/profile_repository.dart';
import '../../view/screens/profile_mixin.dart';
part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> with ProfileMixin {
  final ProfileRepository _repository;
  ProfileCubit(this._repository) : super(ProfileState.initial());

  Future<void> updateProfile(BodyMap data) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.updateProfile(data);
    response.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(message: failure.message))),
      (user) => emit(
        state.copyWith(
          status: CubitStatus.success(data: user, message: LocaleKeys.account_profile_edit_success.tr()),
        ),
      ),
    );
  }
}
