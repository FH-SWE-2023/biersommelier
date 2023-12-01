import 'package:biersommelier/router/PageManager.dart';
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
    context.jump(indexToPage[index]!, change: (change) {
      if (change) {
        setState(() {
          pageIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current page index from the path
    pageIndex = indexToPage.keys.firstWhere(
        (key) => indexToPage[key] == context.path.page,
        orElse: () => 0);
    return NavigationBar(
      onDestinationSelected: navigateTo,
      selectedIndex: pageIndex,
      backgroundColor: Theme.of(context).colorScheme.white,
      shadowColor: Theme.of(context).colorScheme.black,
      destinations: [
        NavigationDestination(
          icon: Image.asset('assets/navbar/Map.png'),
          label: 'Entdecken',
        ),
        NavigationDestination(
          icon: Image.asset('assets/navbar/Hat.png'),
          label: 'Bierkapitän',
        ),
        OverflowBox(
            maxHeight: double.infinity,
            child: Container(
                transform: Matrix4.translationValues(0, -17, 0),
                child: Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () => navigateTo(2),
                      elevation: 2.0,
                      fillColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.all(3.0),
                      shape: const CircleBorder(),
                      child:
                          Image.asset('assets/navbar/AddBeer.png', scale: 3.7),
                    ),
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
          icon: Image.asset('assets/navbar/Heart.png'),
          label: 'Favoriten',
        ),
        NavigationDestination(
          icon: Image.asset('assets/navbar/Log.png'),
          label: 'Logbuch',
        ),
      ],
    );
  }
}
