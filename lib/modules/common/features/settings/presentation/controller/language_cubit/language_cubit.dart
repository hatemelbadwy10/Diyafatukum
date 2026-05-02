import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';

part 'language_state.dart';

@injectable
class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageState.initial());

  Future<void> changeLanguage(String languageCode) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    emit(state.copyWith(status: CubitStatus.success()));
  }
}
