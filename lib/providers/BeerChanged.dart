import 'package:flutter/material.dart';

/// Class to notify the app when the bar list has changed
class BeerChanged extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

