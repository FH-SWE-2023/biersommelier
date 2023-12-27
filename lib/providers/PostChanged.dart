import 'package:flutter/material.dart';

/// Class to notify the app when the beer list has changed
class PostChanged extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}