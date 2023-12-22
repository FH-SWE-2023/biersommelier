import 'package:flutter/material.dart';

class ToastDisplay extends StatefulWidget {
  const ToastDisplay({super.key});

  @override
  State<ToastDisplay> createState() => _ToastDisplayState();
}

class _ToastDisplayState extends State<ToastDisplay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 3,
          child: Container(),
        )
      ],
    );
  }
}
