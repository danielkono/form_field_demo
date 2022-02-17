class IntroState {
  final String? name;
  final String? freeText;
  final String? numbers;
  final String? manualText;
  final String? error;

  IntroState({
    this.name,
    this.freeText,
    this.numbers,
    this.manualText,
    this.error,
  });

  IntroState copyWith({
    String? name,
    String? freeText,
    String? numbers,
    String? manualText,
    String? error,
  }) {
    return IntroState(
      name: name ?? this.name,
      freeText: freeText ?? this.freeText,
      numbers: numbers ?? this.numbers,
      manualText: manualText ?? this.manualText,
      error: error,
    );
  }
}

class LoadingIntroState extends IntroState {}

class ConfirmedIntroState extends IntroState {}
