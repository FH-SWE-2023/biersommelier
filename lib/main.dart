import 'package:biersommelier/providers/BarChanged.dart';
import 'package:biersommelier/providers/BeerChanged.dart';
import 'package:biersommelier/providers/PostChanged.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router/PageManager.dart';
import 'package:flutter/services.dart';
import 'database/DatabaseConnector.dart' as database;

/// Entrypoint der App.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await database.DatabaseConnector.database;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => BeerChanged()),
    ChangeNotifierProvider(create: (context) => BarChanged()),
    ChangeNotifierProvider(create: (context) => PostChanged()),
  ], child: const BierSommelier()));
}

/// Main widget of the app.
class BierSommelier extends StatelessWidget {
  const BierSommelier({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PageManager.app();
  }
}
