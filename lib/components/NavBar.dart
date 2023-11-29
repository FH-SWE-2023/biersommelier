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
        const NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Entdecken'),
        const NavigationDestination(
            icon: Icon(Icons.person_3_outlined),
            selectedIcon: Icon(Icons.person_3),
            label: 'Bierkapitän'),
      OverflowBox(maxHeight: double.infinity, child: Container(
            transform: Matrix4.translationValues(0, -17, 0),
            child: Column(
              children: [
                RawMaterialButton(
                  onPressed: () => navigateTo(2),
                  elevation: 2.0,
                  fillColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.local_drink,
                    size: 35.0,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Hinzufügen', style: TextStyle(fontSize: 11)),
              ],
            ))),
        const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoriten'),
        const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Logbuch'),
      ],
    );
  }
}
