import 'package:biersommelier/components/introduction/IntroductionPage.dart';
import 'package:flutter/material.dart';

class CaptainIntroduction extends StatelessWidget {
  const CaptainIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionPage(
      descriptions: const [
        'Kannst du dich mal schwer entscheiden, in welchem Lokal du welches Bier trinken willst?',
        'Der Bierkapitän gibt dir gerne Empfehlungen.'
      ],
      preview: Image.asset('assets/introduction/captain.png'),
    );
  }
}
