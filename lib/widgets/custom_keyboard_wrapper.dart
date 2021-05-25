import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

KeyboardActionsConfig buildKeyboardActionsConfig(
    BuildContext context, List<FocusNode> nodes) {
  return KeyboardActionsConfig(
    keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
    nextFocus: true,
    actions: nodes.map((e) => KeyboardActionsItem(focusNode: e)).toList(),
  );
}

class CustomKeyboardWrapper extends StatelessWidget {
  const CustomKeyboardWrapper({Key key, this.child, this.keyboardConfig})
      : super(key: key);

  final Widget child;

  final KeyboardActionsConfig keyboardConfig;

  @override
  Widget build(BuildContext context) {
    Widget contents = child;

    if (defaultTargetPlatform == TargetPlatform.iOS && keyboardConfig != null) {
      contents = KeyboardActions(
        config: keyboardConfig,
        child: contents,
      );
    }

    return contents;
  }
}
