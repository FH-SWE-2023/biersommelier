import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        setState(() {
          pageIndex = index;

          if (index != 0) {
            context.go('/other');
          } else {
            context.go('/');
          }
        });
      },
      selectedIndex: pageIndex,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profil')
      ],
    );
  }
}
