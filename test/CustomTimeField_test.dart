import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biersommelier/components/CustomTimeField.dart';

void main() {
  testWidgets('TimeFieldWithLabel renders correctly', (WidgetTester tester) async {
    BuildContext context;


    await tester.pumpWidget(
      Builder(
        builder: (BuildContext innerContext) {
          context = innerContext;
          return MaterialApp(
            home: Scaffold(
              body: TimeFieldWithLabel(
                label: 'Uhrzeit',
                dateTimeFormField: CustomTimeField(
                  context: innerContext,
                  initialValue: DateTime.now(),
                  initialDate: DateTime.now(),
                ),
              ),
            ),
          );
        },
      ),
    );

    // Verify that the label is rendered.
    expect(find.text('Uhrzeit'), findsOneWidget);

    // Verify that the CustomTimeField is rendered.
    expect(find.byType(CustomTimeField), findsOneWidget);
  });

  testWidgets('CustomTimeField renders correctly', (WidgetTester tester) async {
    BuildContext context;

    await tester.pumpWidget(
      Builder(
        builder: (BuildContext innerContext) {
          context = innerContext;
          return MaterialApp(
            home: Scaffold(
              body: CustomTimeField(
                context: innerContext,
                initialValue: DateTime.now(),
                initialDate: DateTime.now(),
              ),
            ),
          );
        },
      ),
    );

    // Verify that the CustomTimeField is rendered.
    expect(find.byType(CustomTimeField), findsOneWidget);

  });

}