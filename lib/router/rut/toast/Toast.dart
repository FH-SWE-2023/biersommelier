import 'package:flutter/material.dart';

enum ToastLevel {
  success,
  warning,
  danger,
}

class Toast extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  static Toast levelToast({
    required String message,
    required ToastLevel level,
  }) {
    Color backgroundColor = const Color(0x00000000);
    Color foregroundColor = const Color(0x00000000);
    IconData icon = Icons.abc;

    switch (level) {
      case ToastLevel.success:
        backgroundColor = const Color(0xffc6da7f);
        foregroundColor = Colors.black;
        icon = Icons.check;
        break;

      case ToastLevel.warning:
        backgroundColor = const Color(0xffffb400);
        foregroundColor = Colors.white;
        icon = Icons.warning_amber_rounded;
        break;

      case ToastLevel.danger:
        backgroundColor = const Color(0xffe20000);
        foregroundColor = Colors.white;
        icon = Icons.clear;
        break;
    }

    return Toast(
      message: message,
      backgroundColor: backgroundColor,
      textColor: foregroundColor,
      icon: icon,
    );
  }

  const Toast({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Roboto",
              textBaseline: null,
              color: textColor,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
