import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_demo/pages/intro/intro_state.dart';

final introProvider = StateNotifierProvider<IntroNotifier, IntroState>(
  (ref) => IntroNotifier(
    IntroState(),
  ),
);

class IntroNotifier extends StateNotifier<IntroState> {
  IntroNotifier(IntroState state) : super(state);

  final nameList = ["günther"];

  void confirm(String? name, String? age, String? reason) async {
    state = LoadingIntroState();
    await Future.delayed(const Duration(seconds: 3));
    
    if (name == null || nameList.contains(name.toLowerCase())) {
      state = state.copyWith(error: "Name already taken!");
      return;
    }
    state = LoadingIntroState();
    await Future.delayed(const Duration(seconds: 3));

    state = ConfirmedIntroState();
  }
}
