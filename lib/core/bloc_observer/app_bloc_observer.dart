import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log('Create ---> ${bloc.runtimeType}', name: "BLoC");
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    log('Close ---> ${bloc.runtimeType}', name: "BLoC");
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(
      'Error  occurred in ${bloc.runtimeType}\n'
      '-----------------StackTrace--------------------\n'
      '${stackTrace.toString()}',
      name: "BLoC",
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log(
      name: "BLoC",
      '-----------------Bloc Transition------------------------\n'
      'bloc: ${bloc.runtimeType}\n'
      'Event: ${transition.event.runtimeType}\n'
      'CurrentState: ${transition.currentState.runtimeType}: ${transition.currentState.toString()} \n'
      'NextState: ${transition.nextState.runtimeType}: ${transition.nextState.toString()} \n'
      '----------------------------------------------------------\n',
    );

    super.onTransition(bloc, transition);
  }

  // @override
  // void onChange(BlocBase bloc, Change change) {
  //   log(
  //     name: "BLoC",

  //     '--------------------------Bloc Change-----------------------\n'
  //     'bloc: ${bloc.runtimeType}\n'
  //     'currentState: ${change.currentState.runtimeType}: ${change.currentState.toString()}\n'
  //     'nextState: ${change.nextState.runtimeType}: ${change.nextState.toString()}\n'
  //     '-------------------------------------------------------------\n',
  //   );
  //   super.onChange(bloc, change);
  // }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log(
      name: "BLoC",
      '--------------------------Bloc Event-----------------------\n'
      'bloc: ${bloc.runtimeType}\n'
      'event: ${event.runtimeType}\n'
      '-------------------------------------------------------------\n',
    );
    super.onEvent(bloc, event);
  }
}
