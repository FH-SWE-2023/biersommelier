import 'package:biersommelier/pages/AddPost.dart';
import 'package:biersommelier/pages/BeerCaptain.dart';
import 'package:biersommelier/pages/Explore.dart';
import 'package:biersommelier/pages/Favorites.dart';
import 'package:biersommelier/pages/Introduction.dart';
import 'package:biersommelier/pages/Logbook.dart';
import 'package:biersommelier/pages/LogoScreen.dart';

import 'package:flutter/material.dart';

enum RutPage {
  explore,
  beerCaptain,
  addPost,
  favorites,
  log,
  introduction,
  logoScreen,
}

class RutPath {
  RutPage page;
  Widget? dialog;
  bool hideStatusBar = false;
  Map<String, Object> arguments;

  RutPath({
    required this.page,
    this.dialog,
    this.hideStatusBar = false,
    this.arguments = const {},
  });

  static RutPath introduction() {
    return RutPath(
      page: RutPage.introduction,
      dialog: null,
      hideStatusBar: true,
    );
  }

  static RutPath homePage() {
    return RutPath(page: RutPage.log);
  }

  static RutPath logoScreen() {
    return RutPath(
      page: RutPage.logoScreen,
      dialog: null,
      hideStatusBar: true,
    );
  }

  static Widget findPage(RutPage page) {
    switch (page) {
      case RutPage.explore:
        return const Explore();

      case RutPage.beerCaptain:
        return const BeerCaptain();

      case RutPage.addPost:
        return const AddPost();

      case RutPage.favorites:
        return const Favorites();

      case RutPage.log:
        return const Logbook();

      case RutPage.introduction:
        return const Introduction();

      case RutPage.logoScreen:
        return const LogoScreen();

      default:
        return const Logbook();
    }
  }
}
