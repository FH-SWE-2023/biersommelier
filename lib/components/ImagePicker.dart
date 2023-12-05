import 'dart:io';
import 'package:biersommelier/components/Toast.dart';
import 'package:flutter/material.dart';
import 'package:biersommelier/imagemanager/ImageManager.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

  Future getImage() async {
    final pickedFile = await ImageManager().pickImage();

    if (!(pickedFile.path.endsWith(".png") ||
        pickedFile.path.endsWith(".jpeg"))) {
      showToast(context, "Falsches Bildformat (PNG/JPEG)", ToastLevel.danger);
    }
    else{
      final _i = File(pickedFile.path);
      if(_i.lengthSync()>52428800){  //50 * 1024*1024 = 50MB
        showToast(context, "Bilddatei zu groß (max. 50MB)", ToastLevel.danger);
      }
      else{
        setState(() {
          _image = _i;
        });
      }
    }
  }

@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(_image == null){
          getImage();
        }
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: Text("Bild ersetzen"),
                        onTap: () {
                          getImage();
                          Navigator.pop(context);
                        },
                      ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: Text("Bild löschen"),
                        onTap: () {
                          setState(() {
                            _image = null;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
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
            ? Icon(Icons.add, size: 100)
            : Image.file(_image!, fit: BoxFit.cover),
      ),
    );
  }
}