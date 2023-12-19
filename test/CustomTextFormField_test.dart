import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biersommelier/components/CustomTextFormField.dart';

void main() {
  testWidgets('CustomTextFormField renders correctly', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return CustomTextFormField(
                context: context,
                labelText: 'Test Label',
                decoration: InputDecoration(),
              );
            },
          ),
        ),
      ),
    );

    // Verify the CustomTextFormField renders correctly.
    expect(find.text('Test Label'), findsOneWidget);
    expect(find.byType(CustomTextFormField), findsOneWidget);
  });


}