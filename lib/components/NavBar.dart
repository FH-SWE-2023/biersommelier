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
        if (index == 1) {
          if (context.path.page == RutPage.home) {
            context.jump(RutPage.explore, change: (change) {
              if (change) {
                setState(() {
                  pageIndex = 1;
                });
              }
            });
          }
        } else {
          if (context.path.page == RutPage.explore) {
            context.blockRouting(
                buttonSuccessText: 'Aber Sicher!',
                buttonCancelText: 'Ne lass mal');
            context.jump(RutPage.home, change: (change) {
              if (change) {
                setState(() {
                  pageIndex = 0;
                });
              }
            });
          }
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
