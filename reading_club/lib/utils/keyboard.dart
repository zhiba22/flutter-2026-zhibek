import 'package:flutter/widgets.dart';

void dismissKeyboard(PointerDownEvent event) {
  FocusManager.instance.primaryFocus?.unfocus();
}
