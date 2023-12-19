import 'package:biersommelier/components/ActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ActionButton widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActionButton(
            onPressed: () {
            },
            child: const Text('Hello World!'),
          ),
        ),
      ),
    );

    // Verify that the button text is rendered.
    expect(find.text('Hello World!'), findsOneWidget);

    // Verify that the CircularProgressIndicator is not rendered when loading is false.
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Tap on the button.
    await tester.tap(find.text('Hello World!'));
    await tester.pump();

    // Verify that the CircularProgressIndicator is rendered when loading is true.
    final actionButtonWithLoading = MaterialApp(
      home: Scaffold(
        body: ActionButton(
          onPressed: () {
          },
          loading: true,
          child: const Text('Hello World!'),
        ),
      ),
    );

    await tester.pumpWidget(actionButtonWithLoading);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}