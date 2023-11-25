import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// Component that displays short information texts with a configurable severity level
///
/// configurable severity level: “success”, “warning”, “danger”
/// (default warning)
///
/// example call:
/// WidgetsBinding.instance.addPostFrameCallback((_){
//       showToast(context, "Hallo Welt", severityLevel.success);
//  });
/// showToast(context,"Hello Wold","success");
///
enum SeverityLevel { success, warning, danger }
showToast(BuildContext context,String message, SeverityLevel level) {

  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  switch (level) {
    case SeverityLevel.success:
      backgroundColor = const Color(0xffc6da7f);
      textColor = Colors.black;
      icon = Icons.check;
    case SeverityLevel.danger:
      backgroundColor = const Color(0xffe20000);
      textColor = Colors.white;
      icon = Icons.clear;
    default: //severityLevel.warning
      backgroundColor = const Color(0xffffb400);
      textColor = Colors.black;
      icon = Icons.warning_amber_rounded;
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





