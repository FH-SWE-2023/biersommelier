import 'package:biersommelier/router/PageManager.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:flutter/material.dart';

/// Beispielwidget für die Navigation Bar
/// Diese Navbar wird nicht bestehen bleiben und ist nur
/// dafür da eine Demo für den Router zu zeigen
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (index) {
        context.jump(RutPage.values[pageIndex], change: (change) {
          if (change) {
            setState(() {
              pageIndex = index;
            });
          }
        });
      },
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
                  onPressed: () {context.jump(RutPage.add, change: (change) {
                    if (change) {
                      setState(() {
                        pageIndex = 2;
                      });
                    }
                  });},
                  elevation: 2.0,
                  fillColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
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
