import 'package:biersommelier/components/CTAButton.dart';
import 'package:biersommelier/components/Toast.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BeerCaptain extends StatelessWidget {
  const BeerCaptain({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('BeerCaptain'),
          const SizedBox(height: 20),
          CTAButton(
              context: context,
              onPressed: () {
                showToast(context, "Hat geklappt", ToastLevel.success);
              },
              child: const Text('Toast zeigen'))
        ],
      ),
    );
  }
}
