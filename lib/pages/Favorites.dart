import 'package:flutter/material.dart';

import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/ExploreTabList.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SafeArea(
          child: Column(
        children: [
          Header(
            title: "Favoriten",
            backgroundColor: Colors.white,
            icon: HeaderIcon.none,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: ExploreBar(onlyFavorites: true),
          ),
        ],
      )),
    );
  }
}
