import 'package:biersommelier/components/Post/BeerIcon.dart';
import 'package:flutter/material.dart';

class RateBar extends StatelessWidget {
  final int rating;
  const RateBar({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    List<BeerIcon> buttons = [];

    for (int i = 0; i < 5; i++) {
      buttons.add(BeerIcon(
        rating > i,
      ));
    }

    return Row(
      children: buttons,
    );
  }
}
