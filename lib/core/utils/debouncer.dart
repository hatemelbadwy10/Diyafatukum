import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class Debouncer {
  final int milliseconds;
  Timer _timer;

  static final Debouncer instance = Debouncer._();

  Debouncer._({this.milliseconds = 300}) : _timer = Timer(Duration(milliseconds: milliseconds), () {});

  void run(void Function() action) {
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

EventTransformer<Event> debounceSequential<Event>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).asyncExpand(mapper);
}
