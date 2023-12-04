import 'package:biersommelier/router/Rut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart';

import  '../theme/theme.dart' as theme;

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
      theme: theme.theme,
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
