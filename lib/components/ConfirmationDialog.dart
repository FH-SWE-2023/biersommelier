import 'package:flutter/material.dart';

/// Confirmation Dialog für Screen, Lastenheft Abbildung 25 (a302-5) (a304-5)
/// - [description] Eine Beschreibung des Prompts
/// - [confirmButtonText] Der Text des bestätigen Buttons
/// - [cancelButtonText] Der Text des abbrechen Buttons
/// - [onConfirm] Callback wenn bestätigen gedrückt wurde
/// - [onCancel] Callback wenn abbrechen gedrückt wurde
class ConfirmationDialog extends StatelessWidget {
  final String description;
  final String confirmButtonText;
  final String cancelButtonText;
  final Function()? onConfirm;
  final Function()? onCancel;

  const ConfirmationDialog({
    super.key,
    this.description =
        'Bist du sicher, dass du\ndiesen Favoriten löschen\nmöchtest?',
    this.confirmButtonText = 'Löschen', //Schriftgröße und Farbe bestimmen
    this.cancelButtonText = 'Abbrechen',
    this.onConfirm,
    this.onCancel,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: onConfirm,
                child: Text(
                  confirmButtonText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 20.0), 
              TextButton(
                onPressed: onCancel,
                child: Text(
                  cancelButtonText,
                  style: const TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}
