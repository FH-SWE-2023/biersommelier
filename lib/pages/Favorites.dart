import 'package:biersommelier/components/CTAButton.dart';
import 'package:biersommelier/router/rut/RutExtension.dart';
import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Favorites'),
          const SizedBox(height: 20),
          CTAButton(
              context: context,
              onPressed: () {
                context.blockRouting(
                  description: 'Routing wieder freigeben?',
                  buttonSuccessText: 'Ja bitte',
                  buttonCancelText: 'Ne passt schon',
                );
              },
              child: const Text('Routing blockieren'))
        ],
      ),
    );
  }
}
