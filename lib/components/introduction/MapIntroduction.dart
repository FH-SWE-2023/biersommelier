import 'package:biersommelier/components/introduction/IntroductionPage.dart';
import 'package:flutter/material.dart';

class MapIntroduction extends StatelessWidget {
  const MapIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionPage(
      descriptions: const [
        'Auf der Karte findest du einige Lokale in deiner Umgebung wobei du neue Lokale selbst hinzufügen kannst.'
      ],
      preview: Image.asset('assets/introduction/map.png'),
    );
  }
}
