import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:biersommelier/router/rut/toast/Toast.dart';
import 'package:flutter/material.dart';

extension RutContext on BuildContext {
  void blockRouting({
    String? description,
    String? buttonSuccessText,
    String? buttonCancelText,
  }) {
    Rut.of(this).blockRouting(
      description: description,
      buttonSuccessText: buttonSuccessText,
      buttonCancelText: buttonCancelText,
    );
  }

  void unblockRouting() {
    Rut.of(this).unblockRouting();
  }

  void jump(
    RutPage page, {
    Function(bool)? change,
    Map<String, Object> arguments = const {},
  }) async {
    return Rut.of(this).jump(
      page,
      change: change,
      arguments: arguments,
    );
  }

  void showToast(Toast toast) {
    Rut.of(this).showToast(toast);
  }

  RutPath get path {
    return Rut.of(this).path;
  }
}
