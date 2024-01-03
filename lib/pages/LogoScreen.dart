import 'package:biersommelier/database/DatabaseConnector.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:flutter/material.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> with TickerProviderStateMixin {
  late final AnimationController controller;
  late Animation<double> fadeInAnimation;
  late Animation<double> fadeOutAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2000,
      ),
    );

    fadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    fadeOutAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.75, 0.85, curve: Curves.easeIn),
      ),
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (DatabaseConnector.isFirstLaunch) {
          Rut.of(context).rebase(RutPath.introduction());
        } else {
          Rut.of(context).rebase(RutPath.homePage());
        }
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeOutAnimation,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFFFFB800),
            ),
            child: Container(),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    child: FadeTransition(
                      opacity: fadeInAnimation,
                      child: Image.asset('assets/logo/logo.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: FadeTransition(
                      opacity: fadeInAnimation,
                      child: Image.asset('assets/logo/title.png'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
