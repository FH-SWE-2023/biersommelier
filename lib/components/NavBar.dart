import 'package:biersommelier/router/rut/toast/Toast.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:flutter/material.dart';

/// The navigation bar positioned at the bottom of the screen
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // The current page index
  int pageIndex = 0;
  // Map the index of the navigation bar to the page
  final indexToPage = {
    0: RutPage.explore,
    1: RutPage.beerCaptain,
    2: RutPage.addPost,
    3: RutPage.favorites,
    4: RutPage.log
  };

  /// Navigate to the page with the given [index]
  void navigateTo(int index) {
    if (indexToPage[index]! != context.path.page) {
      context.jump(indexToPage[index]!, change: (change) {
        if (change) {
          setState(() {
            pageIndex = index;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current page index from the path
    pageIndex = indexToPage.keys.firstWhere(
        (key) => indexToPage[key] == context.path.page,
        orElse: () => 0);
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            offset: const Offset(0, -5),
            blurRadius: 4,
          )
        ],
      ),
      child: NavigationBar(
        elevation: 4,
        onDestinationSelected: navigateTo,
        height: 70,
        selectedIndex: pageIndex,
        backgroundColor: Theme.of(context).colorScheme.white,
        destinations: [
          NavigationDestination(
            icon: Image.asset('assets/icons/map.png', width: 30),
            label: 'Entdecken',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/hat.png', width: 30),
            label: 'Bierkapitän',
          ),
          OverflowBox(
              maxHeight: double.infinity,
              child: Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: OverflowBox(
                            maxHeight: double.infinity,
                            maxWidth: double.infinity,
                            child: Transform.translate(
                              offset: const Offset(0, -5),
                              child: RawMaterialButton(
                                onPressed: () => navigateTo(2),
                                elevation: 2.0,
                                fillColor:
                                    Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.all(3.0),
                                shape: const CircleBorder(),
                                child: Image.asset(
                                  'assets/icons/addBeer.png',
                                  height: 50,
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(height: 6),
                      const Text('Hinzufügen',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                              letterSpacing: 1.5,
                              color: Color(0xff171000))),
                    ],
                  ))),
          NavigationDestination(
            icon: Image.asset('assets/icons/heart.png', width: 30),
            label: 'Favoriten',
          ),
          NavigationDestination(
            icon: Image.asset('assets/icons/log.png', width: 30),
            label: 'Logbuch',
          ),
        ],
      ),
    );
  }
}
