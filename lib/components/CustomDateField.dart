import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';



/*
So verwendest du die Komponente:

DateFieldWithLabel(
  label: "Datum",
  dateTimeFormField: CustomDateField(
    context: context,
    initialValue: DateTime.now(),
    initialDate: DateTime.now(),
  )
)
*/

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
    Key? key,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialValue,
    AutovalidateMode? autovalidateMode,
    bool enabled = true,
    bool use24hFormat = false,
    TextStyle? dateTextStyle,
    //DateFormat? dateFormat,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialDate,
    ValueChanged<DateTime>? onDateSelected,
    //InputDecoration? decoration,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DateTimeFieldPickerMode mode = DateTimeFieldPickerMode.date,
    TimePickerEntryMode initialTimePickerEntryMode = TimePickerEntryMode.dial,
    DateTimeFieldCreator fieldCreator = DateTimeField.new,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          use24hFormat: use24hFormat,
          dateTextStyle: dateTextStyle,
          dateFormat: DateFormat('dd.MM.yyyy'),
          firstDate: firstDate,
          lastDate: lastDate,
          initialDate:initialDate,
          onDateSelected:onDateSelected,
            decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never ,
            
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
          initialEntryMode:initialEntryMode,
          initialDatePickerMode:initialDatePickerMode,
          mode:mode,
          initialTimePickerEntryMode:initialTimePickerEntryMode,
          fieldCreator:fieldCreator,
        );

  @override
  FormFieldState<DateTime> createState() => FormFieldState<DateTime>();
}

