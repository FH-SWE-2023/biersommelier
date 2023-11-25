import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastLevel {
  success,
  warning,
  danger,
}

///
/// Component that displays short information texts with a configurable severity level
///
/// configurable severity level: “success”, “warning”, “danger”
/// (default warning)
///
/// example call:
/// showToast(context,"Hello Wold","success");
///
showToast(BuildContext context, String message, ToastLevel level) {
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  switch (level) {
    case ToastLevel.success:
      backgroundColor = const Color(0xffc6da7f);
      textColor = Colors.black;
      icon = Icons.check;
      break;

    case ToastLevel.warning:
      backgroundColor = const Color(0xffffb400);
      textColor = Colors.black;
      icon = Icons.warning_amber_rounded;
      break;

    case ToastLevel.danger:
      backgroundColor = const Color(0xffe20000);
      textColor = Colors.white;
      icon = Icons.clear;
      break;
  }

  FToast fToast = FToast();
  fToast.init(context);
  Widget toast = Container(
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
            color: textColor,
          ),
        ),
      ],
    ),
  );
  fToast.showToast(
    child: toast,
    toastDuration: const Duration(seconds: 3),
    gravity: ToastGravity.BOTTOM,
  );
}
