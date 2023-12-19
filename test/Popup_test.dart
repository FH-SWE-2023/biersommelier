import 'package:biersommelier/components/Popup/Option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biersommelier/components/Popup.dart';

void main() {
  testWidgets('Popup widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Popup(
          options: [
            Option(
              icon: 'assets/icons/pen_black.png',
              label: 'Weiter bearbeiten',
              color: Colors.black,
              callback: () {},
            ),
            Option(
              icon: 'assets/icons/delete.png',
              label: 'Änderung löschen',
              color: Colors.red[900],
              callback: () {},
            ),
          ],
          onAbort: () {},
        ),
      ),
    );

    expect(find.byType(Popup), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));
  });

  testWidgets('Check if correct function is called on action', (WidgetTester tester) async {
    bool continuePressed = false;
    bool deletePressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Popup.continueWorking(
          pressContinue: () {
            continuePressed = true;
          },
          pressDelete: () {
            deletePressed = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('Weiter bearbeiten'));
    await tester.pump();

    expect(continuePressed, isTrue);
    expect(deletePressed, isFalse);

    await tester.tap(find.text('Änderung löschen'));
    await tester.pump();

    expect(continuePressed, isTrue);
    expect(deletePressed, isTrue);
  });
}