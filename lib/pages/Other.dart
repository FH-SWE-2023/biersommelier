import 'package:biersommelier/router/PageRouter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Ein anderes Fenster. Dieses wird nicht bestehen bleiben
/// und ist nur für die Routerdemo da
class Other extends StatelessWidget {
  const Other({super.key});

  @override
  Widget build(BuildContext context) {
    // Fenster darf nur mit Bestätigung geändert werden
    PageRouter.setUserConfirmation(true);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Andere Seite',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Demoseite für den Router',
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/other/popup');
            },
            child: const Text('Popup'),
          )
        ],
      ),
    );
  }
}
