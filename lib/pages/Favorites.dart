import 'package:flutter/material.dart';

import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/ExploreTabList.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Column(children: [
          Padding(padding: EdgeInsets.only(bottom: 5),
              child: Header(
                title: "Favoriten",
                backgroundColor: Colors.white,
                icon: HeaderIcon.none,
              ),
          ),
          Flexible(
              fit: FlexFit.tight,
              child: ExploreBar(onlyFavorites: true),
          ),
        ],)
    );
  }
}
