part of 'splash_cubit.dart';

class SplashState extends Equatable {
  const SplashState({
    this.isOnboardingViewed = false,
  });

  final bool isOnboardingViewed;

  SplashState copyWith({
    bool? isOnboardingViewed,
  }) {
    return SplashState(
      isOnboardingViewed: isOnboardingViewed ?? this.isOnboardingViewed,
    );
  }

  @override
  List<Object> get props => [isOnboardingViewed];
}
