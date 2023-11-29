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
    this.deleteButtonText = const Text('Löschen', style: TextStyle(color: Colors.red, fontSize: 20.0)),  //Schriftgröße und Farbe bestimmen
    this.cancelButtonText = const Text('Abbrechen', style: TextStyle(color: Colors.black, fontSize: 20.0)),
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
        width: 300.0, // Breite erstellen fuer Container
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 120.0, // Höhe des Textcontainers
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 10.0, right:10.0), //Abstand zwischen Text und Decken(Rahmen)
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0), //Schriftgröße vergrößern
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: delete ?? () => print('Delete pressed'),  //Druckknopfen für "Löschen"
                    child: deleteButtonText,


                  ),
                  TextButton(
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