part of 'bag_cubit.dart';

class BagState extends Equatable {
  const BagState({
    required this.status,
    required this.bag,
  });

  final CubitStatus<void> status;
  final BagModel bag;

  factory BagState.initial() {
    return BagState(
      status: CubitStatus.initial(),
      bag: BagModel(items: []),
    );
  }

  bool get isEmpty => bag.items.isEmpty;

  BagState copyWith({
    CubitStatus<void>? status,
    BagModel? bag,
  }) {
    return BagState(
      status: status ?? this.status,
      bag: bag ?? this.bag,
    );
  }

  @override
  List<Object?> get props => [status, bag];
}
