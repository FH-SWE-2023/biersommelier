import 'package:flutter/material.dart';
import 'router/PageRouter.dart';
import 'database/DatabaseConnector.dart' as database;

/// Entrypoint der App. Hier wird sie gestartet mit dem Hauptwidget
/// Biersommilier.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database.DatabaseConnector dbConnector = database.DatabaseConnector();
  var db = await dbConnector.database;
  runApp(const BierSommelier());
}

/// Biersommelier ist einfach ein Wrapper des PageRouters. Dieser besitzt die
/// Seiteneigenschaften der App.
class BierSommelier extends StatelessWidget {
  const BierSommelier({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PageRouter.app();
  }
}
