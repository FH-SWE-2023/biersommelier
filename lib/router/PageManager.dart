import 'package:biersommelier/router/Rut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import  '../theme/theme.dart' as theme;

final Rut rut = Rut();

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
      routerConfig: rut,

      // Added localization support
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
    );
  }
}
