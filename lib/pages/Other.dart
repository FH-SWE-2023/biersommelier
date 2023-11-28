import 'package:flutter/material.dart';

/// Ein anderes Fenster. Dieses wird nicht bestehen bleiben
/// und ist nur für die Routerdemo da
class Other extends StatelessWidget {
  const Other({super.key});

  @override
  Widget build(BuildContext context) {
    // Fenster darf nur mit Bestätigung geändert werden
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Andere Seite',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Demoseite für den Router',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
