import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String description;
  final Widget deleteButtonText;
  final Widget cancelButtonText;
  final Function()? delete;
  final Function()? cancel;

  const ConfirmationDialog({
    Key? key,
    this.description = 'Bist du sicher, dass du\ndiesen Favoriten löschen\nmöchtest?',
    this.deleteButtonText = const Text('Löschen'),
    this.cancelButtonText = const Text('Abbrechen'),
    this.delete,
    this.cancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: Container(
        width: 300.0, // Breite erstellen fuer Dialogs
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 100.0, // Höhe des Textcontainers
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: delete ?? () => print('Delete pressed'),  //Druckknopfen für "Löschen"
                    child: deleteButtonText,
                  ),
                  OutlinedButton(
                    onPressed: cancel ?? () => print('Cancel pressed'), //Druckknopfen für "Abbrechen"
                    child: cancelButtonText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}