class IntroState {
  final String? error;

  IntroState({this.error});

  IntroState copyWith({String? error}) {
    return IntroState(error: error);
  }
}

class LoadingIntroState extends IntroState {}

class ConfirmedIntroState extends IntroState {}
