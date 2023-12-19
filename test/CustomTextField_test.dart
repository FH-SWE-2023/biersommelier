import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biersommelier/components/CustomTextField.dart';



void main() {
  testWidgets('CustomTextField should render correctly', (WidgetTester tester) async {
    BuildContext? testContext;


    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          testContext = context;
          return MaterialApp(
            home: Scaffold(
              body: TextFieldWithLabel(
                label: 'Test Label',
                textField: CustomTextField(context: context),
              ),
            ),
          );
        },
      ),
    );

    await tester.pump();
    // Verify that the label is rendered.
    expect(find.text('Test Label'), findsOneWidget);

    // Verify that the text field is rendered.
    expect(find.byType(CustomTextField), findsOneWidget);

    // Access testContext for additional tests.
    if (testContext != null) {
      // For example, to test input, you can use tester.enterText() and tester.testTextInput.
      await tester.enterText(find.byType(CustomTextField), 'Test input');
      expect(find.text('Test input'), findsOneWidget);
    }
  });
}
