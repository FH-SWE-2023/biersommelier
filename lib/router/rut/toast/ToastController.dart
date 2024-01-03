import 'dart:collection';

import 'package:biersommelier/router/rut/toast/Toast.dart';
import 'package:flutter/material.dart';

class ToastController {
  final Queue<Toast> _toasts = Queue();
  final Duration showDuration;

  late AnimationController _controller;
  Function(Toast?)? setupToastListener;
  bool _running = true;

  Toast? get first {
    return _toasts.firstOrNull;
  }

  ToastController({
    this.showDuration = const Duration(seconds: 3),
  });

  void _startAnimation() {
    _controller.forward();
  }

  void _showToast() {
    setupToastListener?.call(first);
    _startAnimation();
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Future.delayed(showDuration).then((_) {
        _controller.reverse();
      });
    } else if (status == AnimationStatus.dismissed) {
      _toasts.removeFirst();

      if (_toasts.isNotEmpty) {
        _showToast();
      } else {
        setupToastListener?.call(first);
        _running = false;
      }
    }
  }

  void setSetupListener(Function(Toast?) listener) {
    setupToastListener = listener;
  }

  void setController(AnimationController controller) {
    _controller = controller;
    _controller.addStatusListener(_statusListener);
    _running = false;
  }

  void addToast(Toast toast) {
    _toasts.add(toast);

    if (!_running) {
      _showToast();
    }
  }
}
