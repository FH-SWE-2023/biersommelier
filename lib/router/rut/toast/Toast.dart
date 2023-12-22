import 'package:flutter/material.dart';

enum ToastLevel {
  success,
  warning,
  error,
}

class Toast {
  final String message;
  final Color color;

  static Toast levelToast({
    required String message,
    required ToastLevel level,
  }) {
    Color color = const Color(0x00000000);

    switch (level) {
      case ToastLevel.success:
        color = const Color(0xffc6da7f);
        break;

      case ToastLevel.warning:
        color = const Color(0xffffb400);
        break;

      case ToastLevel.error:
        color = const Color(0xffe20000);
        break;
    }

    return Toast(message: message, color: color);
  }

  Toast({
    required this.message,
    required this.color,
  });
}
