import 'package:biersommelier/router/rut/toast/Toast.dart';
import 'package:biersommelier/router/rut/toast/ToastController.dart';
import 'package:flutter/material.dart';

class ToastDisplay extends StatefulWidget {
  final Duration easeInOutDuration;
  final Duration showDuration;
  final ToastController toastController;

  const ToastDisplay(
    this.toastController, {
    super.key,
    this.easeInOutDuration = const Duration(milliseconds: 300),
    this.showDuration = const Duration(seconds: 3),
  });

  @override
  State<ToastDisplay> createState() => _ToastDisplayState();
}

class _ToastDisplayState extends State<ToastDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Toast? _toast;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.easeInOutDuration,
      vsync: this,
    );

    widget.toastController.setController(_controller);

    widget.toastController.setSetupListener((toast) => _toast = toast);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 3,
          child: Container(),
        ),
        Flexible(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                if (_toast == null) {
                  return Container();
                }

                return Opacity(
                  opacity: _controller.value,
                  child: _toast,
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
