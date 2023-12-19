import 'package:biersommelier/components/introduction/IntroductionPage.dart';
import 'package:flutter/material.dart';

class FavouritesIntroduction extends StatelessWidget {
  const FavouritesIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionPage(
      descriptions: const [
        'Favorisiere deine Lieblingslokale und Lieblingsbiere.',
      ],
      preview: Image.asset('assets/introduction/favourites.png'),
    );
  }
}
