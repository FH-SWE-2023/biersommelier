import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';





class DateFieldWithLabel extends StatelessWidget {

  final String label;
  final CustomDateField dateTimeFormField;
  

  const DateFieldWithLabel({
    super.key, 
    required this.label, 
    required this.dateTimeFormField,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.label,
              style: Theme.of(context).textTheme.bodyLarge
              ),
            this.dateTimeFormField,
          ]
        )
        );
  }
}

class CustomDateField extends DateTimeFormField {

    CustomDateField({
    required BuildContext context,
    String labelText = "",
    Key? key,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialValue,
    AutovalidateMode? autovalidateMode,
    bool enabled = true,
    bool use24hFormat = false,
    TextStyle? dateTextStyle,
    DateFormat? dateFormat,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialDate,
    ValueChanged<DateTime>? onDateSelected,
    InputDecoration? decoration,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DateTimeFieldPickerMode mode = DateTimeFieldPickerMode.dateAndTime,
    TimePickerEntryMode initialTimePickerEntryMode = TimePickerEntryMode.dial,
    DateTimeFieldCreator fieldCreator = DateTimeField.new,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: (FormFieldState<DateTime> field) {
            // Theme defaults are applied inside the _InputDropdown widget
            final InputDecoration _decorationWithThemeDefaults =
                decoration ?? const InputDecoration();

            final InputDecoration effectiveDecoration =
                _decorationWithThemeDefaults.copyWith(
                    errorText: field.errorText);

            void onChangedHandler(DateTime value) {
              if (onDateSelected != null) {
                onDateSelected(value);
              }
              field.didChange(value);
            }

            return fieldCreator(
              firstDate: firstDate,
              initialDate: initialDate,
              lastDate: lastDate,
              decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never ,
            labelText: labelText,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(10),
            ),
            labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary, 
                fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize
                ),
              fillColor: Color.fromARGB(255, 240, 236, 225)
          ),
              initialDatePickerMode: initialDatePickerMode,
              dateFormat: dateFormat,
              onDateSelected: onChangedHandler,
              selectedDate: field.value,
              enabled: enabled,
              use24hFormat: use24hFormat,
              mode: mode,
              initialEntryMode: initialEntryMode,
              dateTextStyle: dateTextStyle,
              initialTimePickerEntryMode: initialTimePickerEntryMode,
            );
          },
        );

  @override
  FormFieldState<DateTime> createState() => FormFieldState<DateTime>();
}

