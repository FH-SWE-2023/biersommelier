import 'package:biersommelier/pages/AddPost.dart';
import 'package:biersommelier/pages/BeerCaptain.dart';
import 'package:biersommelier/pages/Explore.dart';
import 'package:biersommelier/pages/Favorites.dart';
import 'package:biersommelier/pages/Introduction.dart';
import 'package:biersommelier/pages/Logbook.dart';

import 'package:flutter/material.dart';

enum RutPage { explore, beerCaptain, addPost, favorites, log, introduction }

class RutPath {
  RutPage page;
  Widget? dialog;
  bool hideStatusBar = false;

  RutPath({
    required this.page,
    this.dialog,
    this.hideStatusBar = false,
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

      default:
        return const Logbook();
    }
  }
}
