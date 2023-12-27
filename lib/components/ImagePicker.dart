import 'dart:io';
import 'package:flutter/material.dart';
import 'package:biersommelier/components/Toast.dart';
import 'package:biersommelier/imagemanager/ImageManager.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?) onImageSelected;

  File? image;

  ImagePickerWidget({super.key, required this.onImageSelected, this.image});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {


  Future getImage() async {
    try {
      final pickedFile = await ImageManager().pickImage();

      final _i = File(pickedFile.path);
      if (_i.lengthSync() > 50 * 1024 * 1024) {
        // 50 * 1024*1024 = 50MB
        showToast(
            context, "Bilddatei zu groß (max. 50MB)", ToastLevel.danger);
      } else {
        setState(() {
          widget.image = _i;
        });
        widget.onImageSelected(widget.image);
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
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
              widget.image = null;
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

  ImageProvider getImageProvider() {
    // Attempt to determine if the image is a local file or an asset
    final String imagePath = widget.image!.path;
    try {
      // Check if the path is a local file
      final File imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        return FileImage(imageFile);  // Use the image as a local file
      }
    } catch (e) {
      // If there's an error, assume the path references an asset
    }

    var fileName = imagePath.split('/').last;
    fileName = fileName.replaceAll('.jpg', '.png');
    return AssetImage('assets/demo/$fileName');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        if (widget.image == null) {
          getImage();
        } else {
          _showOptionsPopupMenu(context, details.globalPosition);
        }
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: widget.image == null
            ? Image.asset('assets/icons/circle_plus.png', scale: 2,)
            : Image(image: getImageProvider(), fit: BoxFit.cover),
      ),
    );
  }
}
