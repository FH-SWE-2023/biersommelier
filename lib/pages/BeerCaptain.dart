import 'package:biersommelier/components/ActionButton.dart';
import 'package:biersommelier/components/Toast.dart';
import 'package:flutter/material.dart';

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
          ActionButton(
            onPressed: () {
              showToast(context, "Hat geklappt", ToastLevel.success);
            },
            child: const Text('Toast zeigen'),
          )
        ],
      ),
    );
  }
}
