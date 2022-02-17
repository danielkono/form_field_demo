import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_demo/pages/intro/intro_notifier.dart';

class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(introProvider);

    // TODO: implement build
    throw UnimplementedError();
  }
}
