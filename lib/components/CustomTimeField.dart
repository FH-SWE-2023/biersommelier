import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';


/*
So verwendest du die Komponente:

TimeFieldWithLabel(
  label: "Uhrzeit",
  dateTimeFormField: CustomTimeField(
    context: context,
    initialValue: DateTime.now(),
    initialDate: DateTime.now(),
  )
),
*/


class TimeFieldWithLabel extends StatelessWidget {

  final String label;
  final CustomTimeField dateTimeFormField;
  

  const TimeFieldWithLabel({
    super.key, 
    required this.label, 
    required this.dateTimeFormField,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
               padding: const EdgeInsets.all(8.0),
              child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge
              ),
            ),
            dateTimeFormField,
          ]
        )
        );
  }
}

class CustomTimeField extends DateTimeFormField {

    CustomTimeField({
    required BuildContext context,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    super.use24hFormat = true,
    super.dateTextStyle,
    //DateFormat? dateFormat,
    super.firstDate,
    super.lastDate,
    super.initialDate,
    super.onDateSelected,
    //InputDecoration? decoration,
    super.initialEntryMode,
    super.initialDatePickerMode,
    super.mode = DateTimeFieldPickerMode.time,
    super.initialTimePickerEntryMode,
    super.fieldCreator,
  }) : super(
          dateFormat: DateFormat('HH:mm'),
            decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never ,
            
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
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
              fillColor: const Color.fromARGB(255, 240, 236, 225)
          ),
        );

  @override
  FormFieldState<DateTime> createState() => FormFieldState<DateTime>();
}

