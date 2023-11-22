import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String description;
  final Widget successButtonText;
  final Widget cancelButtonText;
  final Function()? success;
  final Function()? cancel;

  const Alert({
    super.key,
    this.title = 'Titel',
    this.description = 'Beschreibung',
    this.success,
    this.cancel,
    this.successButtonText = const Text('Bestätigen'),
    this.cancelButtonText = const Text('Abbrechen'),
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      content: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 30.0),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                description,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: success,
                  child: successButtonText,
                ),
                OutlinedButton(
                  onPressed: cancel,
                  child: cancelButtonText,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
