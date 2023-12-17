import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biersommelier/components/Toast.dart'; // Import the file where showToast function is defined

void main() {
  testWidgets('Test showToast success', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                showToast(context, 'success', ToastLevel.success);
              },
              child: const Text('Show Toast'),
            );
          },
        ),
      ),
    );

    // Tap on the button to trigger the showToast function
    await tester.tap(find.text('Show Toast'));
    await tester.pump();
    expect(find.text('success'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('Test showToast warning', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                showToast(context, 'warning', ToastLevel.warning);
              },
              child: const Text('Show Toast'),
            );
          },
        ),
      ),
    );

    // Tap on the button to trigger the showToast function
    await tester.tap(find.text('Show Toast'));
    await tester.pump();
    expect(find.text('warning'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('Test showToast danger', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                showToast(context, 'danger', ToastLevel.danger);
              },
              child: const Text('Show Toast'),
            );
          },
        ),
      ),
    );

    // Tap on the button to trigger the showToast function
    await tester.tap(find.text('Show Toast'));
    await tester.pump();
    expect(find.text('danger'), findsOneWidget);
    expect(find.byIcon(Icons.clear), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });
}
