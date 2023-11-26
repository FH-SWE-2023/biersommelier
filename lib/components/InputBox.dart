import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});

  @override
  Widget build(BuildContext context){
    return TextField(
      decoration: InputDecoration(
        
              filled:true,
              
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                //borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(23, 16, 0, 1)),
                //borderRadius: BorderRadius.circular(10),
              ),
              
              hintStyle: TextStyle(
                color: const Color.fromRGBO(69, 50, 0, 1), fontSize: 16
                ),
              fillColor:Color.fromRGBO(240, 236, 225, 1),   
              
      )
    );
  }
}