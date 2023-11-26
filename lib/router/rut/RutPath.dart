import 'package:biersommelier/pages/Home.dart';
import 'package:biersommelier/pages/Other.dart';
import 'package:biersommelier/pages/TestExplore.dart';

import 'package:flutter/material.dart';

enum RutPage { home, king, explore, favorites, add }

class RutPath {
  RutPage page;
  Widget? dialog;

  RutPath({
    required this.page,
    this.dialog,
  });

  static Widget findPage(RutPage page) {
    switch (page) {
      case RutPage.home:
        return const Home();

      case RutPage.explore:
        return const TestExplore();

      default:
        return const Home();
    }
  }
}
