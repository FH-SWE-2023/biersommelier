import 'package:biersommelier/components/introduction/IntroductionPage.dart';
import 'package:flutter/material.dart';

class PostsIntroduction extends StatelessWidget {
  const PostsIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionPage(
      descriptions: const [
        'Erstelle Beiträge zu neuen Bieren und bewerte diese.',
        'Schaue durch vergangene Beiträge und verliere nie wieder den Überblick!',
      ],
      preview: Image.asset('assets/introduction/post.png'),
    );
  }
}
