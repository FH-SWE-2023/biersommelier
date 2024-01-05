import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class ImageManager {
  /// Returns the local path of the app
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Returns the image file with the given [key]
  static Future<File> getImageFileByKey(String key) async {
    final path = await _localPath;
    return File('$path/$key.jpg');
  }

  static Future<Image> getImageByKey(String key) async {
    final file = await getImageFileByKey(key);
    if (await file.exists()) {
      return Image.file(file);
    } else {
      // Load a placeholder image
      //return Image.asset('assets/icons/review_full.png');

      // check if image in asstes/demo/key.png exists, if not load assets/icons/review_full.png
      try {
        final image = await rootBundle.load('assets/demo/$key.png');
        return Image.memory(image.buffer.asUint8List());
      } catch (e) {
        return Image.asset('assets/icons/review_full.png');
      }
    }
  }

  /// Saves the given [image] and returns the generated key
  static Future<String> saveImage(File image) async {
    final path = await _localPath;
    const uuid = Uuid();
    String key = uuid.v4();
    await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/$key.jpg',
    );
    return key;
  }

  /// Deletes the image with the given [key]
  /// Returns a Future<FileSystemEntity> that completes with this FileSystemEntity when the deletion is done.
  /// If the FileSystemEntity cannot be deleted, the future completes with an exception.
  static Future<FileSystemEntity> deleteImage(String key) async {
    final path = await _localPath;
    return File('$path/$key.jpg').delete();
  }

  /// Use the native android image picker (available on Android 13+) when calling pickImage().
  /// This function should be called once when the app is initialized.
  static void setupAndroidImagePicker() {
    final ImagePickerPlatform imagePickerImplementation =
        ImagePickerPlatform.instance;
    if (imagePickerImplementation is ImagePickerAndroid) {
      imagePickerImplementation.useAndroidPhotoPicker = true;
    }
  }

  static Future<File> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    // Show dialog to ask user for source type
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Quelle auswählen'),
        children: <Widget>[
          SimpleDialogOption(
            child: const Row(
              children: [
                Icon(Icons.camera),
                SizedBox(width: 16), // Add space between icon and text
                Text('Kamera'),
              ],
            ),
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          SimpleDialogOption(
            child: const Row(
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 16), // Add space between icon and text
                Text('Galerie'),
              ],
            ),
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source == null) {
      // User cancelled the dialog
      throw Exception('No image selected');
    }

    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    } else {
      throw Exception('No image selected');
    }
  }
}
