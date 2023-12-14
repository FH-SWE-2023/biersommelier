import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:flutter/material.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );

    animation = CurvedAnimation(parent: controller!, curve: Curves.easeOut);

    controller!.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Rut.of(context).rebase(RutPath.homePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    opacity: animation!,
                    child: Image.asset('assets/logo/logo.png'),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: FadeTransition(
                    opacity: animation!,
                    child: Image.asset('assets/logo/title.png'),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
