import 'package:biersommelier/router/PageRouter.dart';
import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  const Popup({super.key});

  @override
  Widget build(BuildContext context) {
    PageRouter.setUserConfirmation(true);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Popup',
                textScaleFactor: 2,
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              'Dies ist einfach ein Beispielfester. Die App Bar muss wahrscheinlich hierfür noch entfernt werden.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Wieder schließen'))
          ],
        ),
      ),
    );
  }
}
