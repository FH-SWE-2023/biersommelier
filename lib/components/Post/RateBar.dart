import 'package:biersommelier/components/Post/BeerIcon.dart';
import 'package:flutter/material.dart';

/// Die Bierbewertungsanzeigefläche für einen Beitrag
///
/// - [rating] Eine Integerzahl von 1 bis 5 wie gut das Bier
/// bewertet wurde
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
