import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biersommelier/components/CustomDateField.dart';

void main() {
  testWidgets('DateFieldWithLabel widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return DateFieldWithLabel(
                label: 'Test Datum',
                dateTimeFormField: CustomDateField(
                  context: context,
                  initialValue: DateTime.now(),
                  initialDate: DateTime.now(),
                ),
              );
            },
          ),
        ),
      ),
    );

    // Verify that the label is rendered.
    expect(find.text('Test Datum'), findsOneWidget);

    // Verify that the CustomDateField is rendered.
    expect(find.byType(CustomDateField), findsOneWidget);
  });

  testWidgets('CustomDateField widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return CustomDateField(
                context: context,
                initialValue: DateTime.now(),
                initialDate: DateTime.now(),
              );
            },
          ),
        ),
      ),
    );

    // Verify that the CustomDateField is rendered.
    expect(find.byType(CustomDateField), findsOneWidget);
  });
}