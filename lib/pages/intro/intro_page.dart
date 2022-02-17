import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_demo/pages/intro/intro_notifier.dart';
import 'package:form_field_demo/pages/intro/intro_state.dart';
import 'package:form_field_demo/pages/second/second_page.dart';

///
///https://docs.flutter.dev/cookbook/forms/validation
///https://pub.dev/packages/ensure_visible_when_focused/example
///
class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage> {
  //controller used to get text from fields

  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _numberController = TextEditingController();
  late final TextEditingController _freeTextController =
      TextEditingController();

  // focus nodes used to request focus
  // change focus and scroll to focused widget via [EnsureVisibleWhenFocused]
  late final FocusNode _nameFocusNode = FocusNode();
  late final FocusNode _numberFocusNode = FocusNode();
  late final FocusNode _freeTextFocusNode = FocusNode();
  late final FocusNode _requestFocusNode = FocusNode();

  /// Important key
  /// we can use it to call [validate] function that will
  /// validate all children within the form using this key
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _freeTextController.dispose();

    _nameFocusNode.dispose();
    _numberFocusNode.dispose();
    _freeTextFocusNode.dispose();
    _requestFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(introProvider);

    // listen for changes so we can change route
    ref.listen(introProvider, (previous, next) {
      if (next is ConfirmedIntroState) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SecondPage()));
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EnsureVisibleWhenFocused(
                        focusNode: _nameFocusNode,
                        child: TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          autovalidateMode: AutovalidateMode.always,
                          decoration: InputDecoration(
                            errorText: state
                                .error, // <- provide manual error text, like for async validation in notifier
                            hintText: "Enter name",
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              //request focus so it will automatically scroll to top wen there is a error
                              //not working with async case
                              _nameFocusNode.requestFocus();
                              return "Cannot be empty";
                            }
                          },
                          onFieldSubmitted: (text) {
                            //change focus on submit
                            _nextField(_nameFocusNode, _numberFocusNode);
                          },
                        ),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _numberFocusNode,
                        child: TextFormField(
                          controller: _numberController,
                          focusNode: _numberFocusNode,
                          decoration:
                              const InputDecoration(hintText: "Enter age"),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Cannot be empty";
                            }

                            if (val.length > 10) {
                              return "max length is 10";
                            }

                            if (int.tryParse(val) == null) {
                              return "must be a number";
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onFieldSubmitted: (text) {
                            _nextField(_numberFocusNode, _freeTextFocusNode);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 900,
                        child: Center(
                          child: Text("random text"),
                        ),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _freeTextFocusNode,
                        child: TextFormField(
                          controller: _freeTextController,
                          focusNode: _freeTextFocusNode,
                          decoration:
                              const InputDecoration(hintText: "Add reason"),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Cannot be empty";
                            }
                            if (val.split(" ").length > 3) {
                              return "max words are 3";
                            }
                          },
                          autovalidateMode: AutovalidateMode.disabled,
                          onFieldSubmitted: (text) {
                            _nextField(_freeTextFocusNode, _requestFocusNode);
                          },
                        ),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _requestFocusNode,
                        child: OutlinedButton(
                            focusNode: _requestFocusNode,
                            onPressed: () {
                              if (_formKey.currentState?.validate() == true) {
                                ref.read(introProvider.notifier).confirm(
                                      _nameController.text,
                                      _numberController.text,
                                      _freeTextController.text,
                                    );
                              }
                            },
                            child: const Text("Send request")),
                      ),
                    ],
                  ),
                )),
          ),
          if (state
              is LoadingIntroState) // display simple loading indicator wen in loading state
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  /// helper function to change focus
  /// not complete, missing checks for has focus etc.
  void _nextField(FocusNode previous, FocusNode next) {
    previous.unfocus();
    next.requestFocus();
  }
}
