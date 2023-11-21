import 'package:biersommelier/components/NavBar.dart';
import 'package:biersommelier/pages/Home.dart';
import 'package:biersommelier/pages/Other.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageRouter {
  /// Diese Methode ersetzt router durch die benötigten
  /// Eigenschaften der App (Hintergrundfarbe uä)
  static MaterialApp app() {
    return MaterialApp.router(
      title: 'Biersommelier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        useMaterial3: true,
      ),
      routerConfig: PageRouter.router(),
    );
  }

  /// Der eigentliche Entrypoint des Routers
  static GoRouter router() {
    return GoRouter(
      routes: [
        ShellRoute(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Home(),
            ),
            GoRoute(path: '/other',
            builder: (context, state) => const Other()),
          ],
          pageBuilder: (context, state, child) {
            // Der scaffold und die Navbar sind immer sichtbar
            // Dies kann sich bei programmierung der introduction
            // abändern
            return NoTransitionPage(child:
            Scaffold(
              appBar: AppBar(
                title: Text('Biersommelier'),
              ),
              body: child,
              bottomNavigationBar: const NavBar(),
            ));
          }
        )
      ]
    );
  }
}