import 'package:biersommelier/components/introduction/PostsIntroduction.dart';
import 'package:biersommelier/components/introduction/ProgressIntroductionIndicator.dart';
import 'package:flutter/material.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return SafeArea(
      child: Column(
        children: [
          ProgressIntroductionIndicator(controller: controller, count: 3),
          Expanded(
            child: PageView(
              controller: controller,
              children: [
                PostsIntroduction(),
                PostsIntroduction(),
                PostsIntroduction(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
