import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Confirmation Dialog für Screen, Lastenheft Abbildung 25 (a302-5) (a304-5)
class ConfirmationDialog extends StatelessWidget {
  final String description;
  final Widget deleteButtonText;
  final Widget cancelButtonText;
  final Function()? delete;
  final Function()? cancel;

  const ConfirmationDialog({
    super.key,
    this.description =
        'Bist du sicher, dass du\ndiesen Favoriten löschen\nmöchtest?',
    this.deleteButtonText = const Text('Löschen',
        style: TextStyle(
            color: Colors.red,
            fontSize: 20.0)), //Schriftgröße und Farbe bestimmen
    this.cancelButtonText = const Text('Abbrechen',
        style: TextStyle(color: Colors.black, fontSize: 20.0)),
    this.delete,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        width: 300.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 10,
              ),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w400),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: delete,
                  child: deleteButtonText,
                ),
                TextButton(
                  onPressed: cancel,
                  child: cancelButtonText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
