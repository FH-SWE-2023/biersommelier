import 'package:biersommelier/components/CTAButton.dart';
import 'package:biersommelier/components/Popup.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Entdecken'),
          SizedBox(height: 20),
          CTAButton(
            context: context,
            onPressed: () {
              Rut.of(context).showDialog(
                Popup.continueWorking(pressContinue: () {
                  Rut.of(context).showDialog(null);
                }, pressDelete: () {
                  Rut.of(context).showDialog(null);
                }),
              );
            },
            child: Text('Popup'),
          ),
        ],
      ),
    );
  }
}
