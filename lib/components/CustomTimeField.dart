import 'package:flutter/material.dart';




class TimeFieldWithLabel extends State<>{

    DateTime cur = DateTime.now();

    @override
    Widget build(BuildContext context) => Scaffold(
      body: ElevatedButton(
          child: Text(cur.toString()),
          onPressed: () async {
            DateTime? newDate = await showDatePicker(
              context: context, 
              initialDate: cur,
              firstDate: DateTime(2000), 
              lastDate: DateTime(2100)
              );

              if(newDate == null) return;

              setState(() {
                cur = newDate;
              });
              cur = newDate;
          },
          )
    
    );
}