import 'package:biersommelier/components/Alert.dart';
import 'package:biersommelier/components/NavBar.dart';
import 'package:biersommelier/pages/Home.dart';
import 'package:biersommelier/pages/Other.dart';
import 'package:biersommelier/pages/TestPopup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// As Flutter does not expose these color types, we have to extend them ourselves
extension AppColorScheme on ColorScheme {
  Color get success => const Color(0xFFB4CF67);
  Color get lightSecondary => const Color(0xFF946C00);
  Color get hint => const Color(0xFF2187FF);
  Color get white => const Color(0xFFFFFFFF);
  Color get black => const Color(0xFF000000);
}

class PageRouter {
  static bool userConfirmation = false;
  static String currentPage = '/';

  /// Diese Methode ersetzt router durch die benötigten
  /// Eigenschaften der App (Hintergrundfarbe uä)
  static MaterialApp app() {
    return MaterialApp.router(
      title: 'Biersommelier',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFFFFB800),
          secondary: Color(0xFF453200),
          surface: Color(0xFFFFFFFF),
          background: Color(0xFFFFFFFF),
          error: Color(0xFFC00000),
          onPrimary: Color(0xFFFFFFFF),
          onSecondary: Color(0xFFFFFFFF),
          onSurface: Color(0xFF171000),
          onBackground: Color(0xFF171000),
          onError: Color(0xFFFFFFFF),
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(
              fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(
              fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(
              fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(
              fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.normal),
          bodySmall: TextStyle(
              fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.normal),
        ),
        useMaterial3: false,
      ),
      routerConfig: PageRouter.router(),
    );
  }

  /// Der eigentliche Entrypoint des Routers
  static GoRouter router() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Home(),
            ),
            GoRoute(
              path: '/other',
              builder: (context, state) => const Other(),
              routes: [
                GoRoute(
                  path: 'popup',
                  builder: (context, state) => const Popup(),
                ),
              ],
            ),
          ],
          pageBuilder: (context, state, child) {
            // Der scaffold und die Navbar sind immer sichtbar
            // Dies kann sich bei programmierung der introduction
            // abändern
            return NoTransitionPage(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Biersommelier'),
                ),
                body: child,
                bottomNavigationBar: const NavBar(),
              ),
            );
          },
        )
      ],
    );
  }

  /// Setzt ob eine Nutzerbestätigung bei Seitenwechsel erforderlich ist
  static void setUserConfirmation(bool userConfirmation) {
    PageRouter.userConfirmation = userConfirmation;
  }

  /// Aktualisiert den angezeigten Seitennamen
  static void updatePage(BuildContext context) {
    PageRouter.currentPage = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .matches
        .last
        .matchedLocation;
  }
}

/// Eine Erweiterung um sicher nach Bestätigung des Nutzers auf eine
/// andere Seite routen zu können
extension SafeRouter on BuildContext {
  /// Fragt an ob zu einer anderen Seite geleitet werden kann.
  /// Dies wird immer bestätigt wenn [PageRouter.userConfirmation]
  /// `falsch` ist. Andernfalls wird der Nutzers gefragt ob er dies
  /// wirklich möchte.
  Future<void> go(String location) async {
    if (!PageRouter.userConfirmation) {
      GoRouter.of(this).go(location);
      PageRouter.updatePage(this);
    } else {
      await showDialog(
        context: this,
        builder: (context) {
          return Alert(
            title: "Seite wirklich verlassen?",
            description:
                "Wenn du die Seite verlässt werden deine Daten nicht gespeichert",
            cancel: () {
              GoRouter.of(context).pop();
            },
            success: () {
              PageRouter.currentPage = location;
              GoRouter.of(context).pop();
              GoRouter.of(context).go(location);
              PageRouter.setUserConfirmation(false);
            },
          );
        },
      );
    }
  }

  /// Rendert ein Fester über ein anderes
  void push(String location) {
    PageRouter.currentPage = location;
    GoRouter.of(this).push(location);
  }

  /// Fragt an ob das oberste Fenster entfernt werden kann. Dies wird immer
  /// ausgeführt wenn [PageRouter.userConfirmation] auf `falsch` ist. Ansonsten wird
  /// der Nutzer gefragt ob er dies wirklich möchte.
  Future<void> pop() async {
    if (!PageRouter.userConfirmation) {
      GoRouter.of(this).pop();
      PageRouter.updatePage(this);
    } else {
      await showDialog(
        context: this,
        builder: (context) {
          return Alert(
            title: "Seite wirklich verlassen?",
            description:
                "Wenn du die Seite verlässt werden deine Daten nicht gespeichert",
            cancel: () {
              GoRouter.of(context).pop();
            },
            success: () {
              GoRouter.of(context).pop();
              GoRouter.of(context).pop();
              PageRouter.updatePage(context);
              PageRouter.setUserConfirmation(false);
            },
          );
        },
      );
    }
  }
}
