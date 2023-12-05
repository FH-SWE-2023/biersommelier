import 'package:flutter/material.dart';

class Option {
  String icon;
  String label;
  Color? color;
  Function()? callback;

  Option({
    required this.icon,
    required this.label,
    this.color,
    this.callback,
  });
}
