import 'dart:io'; // Add this import statement
import 'package:biersommelier/components/ActionButton.dart';
import 'package:biersommelier/router/rut/RutExtension.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/components/ImagePicker.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Favorites'),
          const SizedBox(height: 20),
          ActionButton(
            onPressed: () {
              context.blockRouting(
                description: 'Routing wieder freigeben?',
                buttonSuccessText: 'Ja bitte',
                buttonCancelText: 'Ne passt schon',
              );
            },
            child: const Text('Routing blockieren'),
          ),
          const SizedBox(height: 20),
          ImagePickerWidget(
            onImageSelected: (image) {
              setState(() {
                selectedImage = image;
              });
            },
          ),
          // HIER EIN BEISPIEL WIE MAN DAS BILD BZW AUCH DEN PFAD ZUM BILD BEKOMMT
          const SizedBox(height: 20),
          if (selectedImage != null)
            Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.file(selectedImage!, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Text(
                  'Bildpfad: ${selectedImage?.path ?? "Kein Bild ausgewählt"}',
                ),
              ],
            ),
        ],
      ),
    );
  }
}
