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
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
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
             ),
          
          
        );
        
  }
}

class CustomDateField extends DateTimeFormField {

    CustomDateField({
    required BuildContext context,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    super.use24hFormat,
    super.dateTextStyle,
    //DateFormat? dateFormat,
    super.firstDate,
    super.lastDate,
    super.initialDate,
    super.onDateSelected,
    //InputDecoration? decoration,
    super.initialEntryMode,
    super.initialDatePickerMode,
    super.mode = DateTimeFieldPickerMode.date,
    super.initialTimePickerEntryMode,
    super.fieldCreator,
  }) : super(
          dateFormat: DateFormat('dd.MM.yyyy'),
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

