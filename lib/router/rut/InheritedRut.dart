import 'package:biersommelier/router/Rut.dart';
import 'package:flutter/material.dart';

class InheritedRut extends InheritedWidget {
  final Rut rut;
  const InheritedRut({
    required super.child,
    required this.rut,
    super.key,
  });

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static InheritedRut? of(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<InheritedRut>()
        ?.widget as InheritedRut?;
  }
}
