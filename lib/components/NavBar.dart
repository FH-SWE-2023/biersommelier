import 'package:biersommelier/router/PageRouter.dart';
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

  // Ziemliches Mess, jedoch ist das nur ein Demokomponent
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (index) {
        if (PageRouter.currentPage == '/') {
          context.go('/other').then((_) {
            if (PageRouter.currentPage == '/other') {
              setState(() {
                pageIndex = 1;
              });
            }
          });
        } else {
          context.go('/').then((_) {
            if (PageRouter.currentPage == '/') {
              setState(() {
                pageIndex = 0;
              });
            }
          });
        }
      },
      selectedIndex: pageIndex,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profil')
      ],
    );
  }
}
