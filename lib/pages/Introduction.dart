import 'package:biersommelier/components/introduction/CaptainIntroduction.dart';
import 'package:biersommelier/components/introduction/FavouritesIntroduction.dart';
import 'package:biersommelier/components/introduction/MapIntroduction.dart';
import 'package:biersommelier/components/introduction/PostsIntroduction.dart';
import 'package:biersommelier/components/introduction/ProgressIntroductionIndicator.dart';
import 'package:biersommelier/database/DatabaseConnector.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
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
          ProgressIntroductionIndicator(
            controller: controller,
            count: 4,
            onPressed: () {
              int nextPage = (1 + controller.page!.round()).toInt();
              if (nextPage <= 4 - 1) {
                controller.animateToPage(
                  nextPage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } else {
                DatabaseConnector.introductionComplete();
                Rut.of(context).rebase(RutPath.homePage());
              }
            },
          ),
          Expanded(
            child: PageView(
              controller: controller,
              children: const [
                PostsIntroduction(),
                FavouritesIntroduction(),
                CaptainIntroduction(),
                MapIntroduction(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
