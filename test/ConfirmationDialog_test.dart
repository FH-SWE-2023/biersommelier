import 'package:biersommelier/components/ConfirmationDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('ConfirmationDialog displays correct text', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: Builder(
          builder: (BuildContext context) {
            return TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ConfirmationDialog(
                      description: 'Test description',
                      confirmButtonText: 'Confirm',
                      cancelButtonText: 'Cancel',
                    );
                  },
                );
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      ),
    ));

    // Tap the button to trigger the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify that the dialog displays the correct text
    expect(find.text('Test description'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('ConfirmationDialog calls onConfirm and onCancel callbacks', (WidgetTester tester) async {
    bool onConfirmCalled = false;
    bool onCancelCalled = false;

    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: Builder(
          builder: (BuildContext context) {
            return TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      description: 'Description Test!',
                      confirmButtonText: 'Confirm',
                      cancelButtonText: 'Cancel',
                      onConfirm: () {
                        onConfirmCalled = true;
                      },
                      onCancel: () {
                        onCancelCalled = true;
                      },
                    );
                  },
                );
              },
              child: const Text('Show Dialog'),
            );
          },
        ),
      ),
    ));

    // Tap the button to trigger the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Description Test!'), findsOneWidget);

    // Tap on the Confirm button
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    // Verify that onConfirm callback is called
    expect(onConfirmCalled, true);
    expect(onCancelCalled, false);

    // Tap on the Cancel button
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify that onCancel callback is called
    expect(onCancelCalled, true);
  });
}
