import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:flutter/material.dart';

extension RutContext on BuildContext {
  void blockRouting({
    String? title,
    String? description,
    String? buttonSuccessText,
    String? buttonCancelText,
  }) {
    Rut.of(this).blockRouting(
      title: title,
      description: description,
      buttonSuccessText: buttonSuccessText,
      buttonCancelText: buttonCancelText,
    );
  }

  void unblockRouting() {
    Rut.of(this).unblockRouting();
  }

  void jump(RutPage page, {Function(bool)? change}) async {
    return Rut.of(this).jump(page, change: change);
  }

  RutPath get path {
    return Rut.of(this).path;
  }
}
