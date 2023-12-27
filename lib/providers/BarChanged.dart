import 'package:flutter/material.dart';

/// Class to notify the app when the beer list has changed
class BarChanged extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}