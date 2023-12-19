import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/InheritedRut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biersommelier/components/NavBar.dart';

void main() {
  testWidgets('NavBar widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: InheritedRut(
          rut: Rut(),
          child: const Scaffold(
            body: NavBar(),
          ),
        ),
      ),
    );

    // Verify that the NavBar is rendered.
    expect(find.byType(NavBar), findsOneWidget);

    // Verify that the initial page index is set correctly.
    expect(find.text('Entdecken'), findsOneWidget);
    expect(find.text('Bierkapitän'), findsOneWidget);
    expect(find.text('Hinzufügen'), findsOneWidget);
    expect(find.text('Favoriten'), findsOneWidget);
    expect(find.text('Logbuch'), findsOneWidget);

    // Simulate a tap on the "Bierkapitän" tab.
    await tester.tap(find.text('Bierkapitän'));
    await tester.pump();

    // Simulate a tap on the "Hinzufügen" button.
    await tester.tap(find.byType(RawMaterialButton));
    await tester.pump();

    // Verify that the navigation method is called correctly.
    expect(find.text('Entdecken'), findsOneWidget);
    expect(find.text('Bierkapitän'), findsOneWidget);
    expect(find.text('Hinzufügen'), findsOneWidget);
    expect(find.text('Favoriten'), findsOneWidget);
    expect(find.text('Logbuch'), findsOneWidget);
  });
}
