import 'dart:io';
import 'package:flutter/material.dart';
import 'package:biersommelier/components/Toast.dart';
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
        if (_i.lengthSync() > 50 * 1024 * 1024) {
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

  void _showOptionsPopupMenu(BuildContext context, Offset position) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect positionRelativeRect = RelativeRect.fromRect(
      Rect.fromPoints(position, position),
      Offset.zero & overlay.size,
    );

    final result = await showMenu(
      context: context,
      position: positionRelativeRect,
      items: [
        PopupMenuItem(
          onTap: () {
            getImage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/icons/pen_black.png', scale: 3.5,), // Statt Icon(Icons.edit_outlined)
              const Text("Bild ersetzen"),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            setState(() {
              _image = null;
            });
            // Callback aufrufen, um mitzuteilen, dass das Bild gelöscht wurde
            widget.onImageSelected(null);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/icons/delete.png', scale: 3.5),
              const Text("Bild löschen"),
            ],
          ),
        ),
      ],
    );

    if (result != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        if (_image == null) {
          getImage();
        } else {
          _showOptionsPopupMenu(context, details.globalPosition);
        }
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 236, 225),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _image == null
            ? Image.asset('assets/icons/circle_plus.png')
            : Image.file(_image!, fit: BoxFit.cover),
      ),
    );
  }
}
