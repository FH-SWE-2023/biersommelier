import 'package:biersommelier/pages/AddPost.dart';
import 'package:biersommelier/pages/BeerCaptain.dart';
import 'package:biersommelier/pages/Explore.dart';
import 'package:biersommelier/pages/Favorites.dart';
import 'package:biersommelier/pages/Logbook.dart';

import 'package:flutter/material.dart';

enum RutPage { explore, beerCaptain, addPost, favorites, log }

class RutPath {
  RutPage page;
  Widget? dialog;

  RutPath({
    required this.page,
    this.dialog,
  });

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

      default:
        return const Logbook();
    }
  }
}
