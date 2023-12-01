import 'package:biersommelier/router/Rut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// As Flutter does not expose these color types, we have to extend them ourselves
extension AppColorScheme on ColorScheme {
  Color get success => const Color(0xFFB4CF67);
  Color get lightSecondary => const Color(0xFF946C00);
  Color get hint => const Color(0xFF2187FF);
  Color get white => const Color(0xFFFFFFFF);
  Color get black => const Color(0xFF000000);
}

class PageManager {
  static bool userConfirmation = false;

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
      // Rut (Rille) ist ein selbstimplemeniterter Router. Da dieser visuell unter den anderen
      // Komponenten befindet heißt er nun so als hätte man Router falsch geschrieben.
      routerConfig: Rut(),

      // Added localization support
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
    );
  }
}
