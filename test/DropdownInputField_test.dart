import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biersommelier/components/DropdownInputField.dart';

class TestDropdownOption extends DropdownOption {
  TestDropdownOption({required String name, required String icon, String? address})
      : super(name: name, icon: icon, address: address);
}

void main() {
  testWidgets('DropdownInputField displays options correctly', (WidgetTester tester) async {
    String? selectedOption;
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DropdownInputField(
            labelText: 'Select Option',
            optionsList: [
              TestDropdownOption(name: 'Option1', icon: 'delete.png', address: 'Address1'),
              TestDropdownOption(name: 'Option2', icon: 'delete.png', address: 'Address2')
            ],
            onOptionSelected: (option) {
              selectedOption = option.name;
            },
          ),
        ),
      ),
    );

    // Tap on the TextFormField to open the dropdown
    await tester.tap(find.byType(TextFormField));
    await tester.pump();

    expect(find.text('Option1 '), findsOneWidget);
    expect(find.text('Option2 '), findsOneWidget);

    await tester.tap(find.text('Option1 '));
    await tester.pump();
    expect(selectedOption, 'Option1');
  });
}
