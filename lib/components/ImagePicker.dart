import 'dart:io';
import 'package:biersommelier/components/Toast.dart';
import 'package:flutter/material.dart';
import 'package:biersommelier/imagemanager/ImageManager.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?) onImageSelected;

  const ImagePickerWidget({super.key, required this.onImageSelected});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

  Future getImage() async {
    try {
      final pickedFile = await ImageManager().pickImage();

      if (!(pickedFile.path.endsWith(".png") ||
          pickedFile.path.endsWith(".jpeg"))) {
        showToast(context, "Falsches Bildformat (PNG/JPEG)", ToastLevel.danger);
      } else {
        final _i = File(pickedFile.path);
        if (_i.lengthSync() > 50*1024*1024) {
          // 50 * 1024*1024 = 50MB
          showToast(
              context, "Bilddatei zu groß (max. 50MB)", ToastLevel.danger);
        } else {
          setState(() {
            _image = _i;
          });
          widget.onImageSelected(_image);
        }
      }
    } catch (e) {
      if (e.toString() != "Exception: No image selected") {
        showToast(context, "Fehler beim Laden des Bildes", ToastLevel.danger);
      }
    }
  }

  void _showOptionsModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () {
                getImage();
                Navigator.pop(context);
              },
              title: const Text("Bild ersetzen"),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _image = null;
                });
                Navigator.pop(context);

                // Callback aufrufen, um mitzuteilen, dass das Bild gelöscht wurde
                widget.onImageSelected(null);
              },
              title: const Text("Bild löschen"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_image == null) {
          getImage();
        } else {
          _showOptionsModal();
        }
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: _image == null
            ? const Icon(Icons.add, size: 100)
            : Image.file(_image!, fit: BoxFit.cover),
      ),
    );
  }
}