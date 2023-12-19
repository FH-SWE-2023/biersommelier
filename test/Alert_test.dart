import 'package:biersommelier/components/Alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Variables to track whether the success and cancel callbacks are called.
  bool successCallbackCalled = false;
  bool cancelCallbackCalled = false;

  group('Alert Widget Test', () {
    testWidgets('Renders default values', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Alert(),
          ),
        ),
      );

      // Verify that the default title and description are rendered.
      expect(find.text('Titel'), findsOneWidget);
      expect(find.text('Beschreibung'), findsOneWidget);

      // Verify that the default button texts are rendered.
      expect(find.text('Bestätigen'), findsOneWidget);
      expect(find.text('Abbrechen'), findsOneWidget);

      // Verify that the success and cancel callbacks are not called by default.
      // (You may need to modify this part based on your specific requirements)
      expect(successCallbackCalled, isFalse);
      expect(cancelCallbackCalled, isFalse);
    });

    testWidgets('Renders custom values and invokes callbacks', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Alert(
              title: 'Custom Title',
              description: 'Custom Description',
              success: () {
                successCallbackCalled = true;
              },
              cancel: () {
                cancelCallbackCalled = true;
              },
              successButtonText: const Text('Custom Confirm'),
              cancelButtonText: const Text('Custom Cancel'),
            ),
          ),
        ),
      );

      // Verify that the custom title and description are rendered.
      expect(find.text('Custom Title'), findsOneWidget);
      expect(find.text('Custom Description'), findsOneWidget);

      // Verify that the custom button texts are rendered.
      expect(find.text('Custom Confirm'), findsOneWidget);
      expect(find.text('Custom Cancel'), findsOneWidget);

      // Tap on the success button and verify that the success callback is invoked.
      await tester.tap(find.text('Custom Confirm'));
      await tester.pump();
      expect(successCallbackCalled, isTrue);
      expect(cancelCallbackCalled, isFalse);

      // Tap on the cancel button and verify that the cancel callback is invoked.
      await tester.tap(find.text('Custom Cancel'));
      await tester.pump();
      expect(successCallbackCalled, isTrue);
      expect(cancelCallbackCalled, isTrue);
    });
  });
}

