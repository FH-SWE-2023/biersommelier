import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class KeyboardSafeArea extends StatefulWidget {
  final Widget Function(BuildContext context, bool visible) builder;

  const KeyboardSafeArea({super.key, required this.builder});

  @override
  State<KeyboardSafeArea> createState() => _KeyboardSafeAreaState();
}

class _KeyboardSafeAreaState extends State<KeyboardSafeArea> {
  double _keyboardHeight = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, visible) {
      _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

      return Positioned(
        left: 0,
        right: 0,
        height: MediaQuery.of(context).size.height - _keyboardHeight,
        child: widget.builder(context, _keyboardHeight != 0),
      );
    });
  }
}
