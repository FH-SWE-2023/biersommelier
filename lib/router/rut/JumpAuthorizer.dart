import 'package:biersommelier/components/Alert.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:flutter/material.dart';

class JumpAuthorizer {
  bool _active = false;
  String? customTitle;
  String? customDescription;
  String defaultTitle;
  String defaultDescription;
  String? customButtonSuccessText;
  String? customButtonCancelText;
  String defaultButtonSuccessText;
  String defaultButtonCancelText;

  JumpAuthorizer({
    required this.defaultTitle,
    required this.defaultDescription,
    required this.defaultButtonSuccessText,
    required this.defaultButtonCancelText,
  });

  void userRequestMode() {
    _active = true;
  }

  void grantMode() {
    _active = false;
  }

  void setPrompt({
    String? title,
    String? description,
    String? buttonSuccessText,
    String? buttonCancelText,
  }) {
    customTitle = title;
    customDescription = description;
    customButtonSuccessText = buttonSuccessText;
    customButtonCancelText = buttonCancelText;
  }

  void _clearCustomMessages() {
    customTitle = null;
    customDescription = null;
    customButtonSuccessText = null;
    customButtonCancelText = null;
  }

  void authorizeJump(Rut rut, Function(bool) authorized) {
    if (_active) {
      rut.showDialog(
        Alert(
          title: customTitle ?? defaultTitle,
          description: customDescription ?? defaultDescription,
          successButtonText:
              Text(customButtonSuccessText ?? defaultButtonSuccessText),
          cancelButtonText:
              Text(customButtonCancelText ?? defaultButtonCancelText),
          cancel: () {
            rut.showDialog(null);
            authorized.call(false);
          },
          success: () {
            rut.showDialog(null);
            grantMode();
            _clearCustomMessages();
            authorized.call(true);
          },
        ),
      );
    } else {
      _clearCustomMessages();
      authorized.call(true);
    }
  }
}
