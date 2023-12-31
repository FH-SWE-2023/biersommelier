import 'dart:io';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

class ImageManager {
  /// Returns the local path of the app
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Returns the image file with the given [key]
  Future<File> getImageFileByKey(String key) async {
    final path = await _localPath;
    return File('$path/$key.jpg');
  }

  Future<Image> getImageByKey(String key) async {
    final file = await getImageFileByKey(key);
    if (await file.exists()) {
      return Image.file(file);
    } else {
      // Load a placeholder image
      //return Image.asset('assets/icons/review_full.png');

      // check if image in assets/demo/key.png exists, if not load assets/icons/review_full.png
      try {
        final image = await rootBundle.load('assets/demo/$key.png');
        return Image.memory(image.buffer.asUint8List());
      } catch (e) {
        return Image.asset('assets/icons/review_full.png');
      }
    }
  }

  /// Saves the given [image] and returns the generated key
  Future<String> saveImage(File image) async {
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
  Future<FileSystemEntity> deleteImage(String key) async {
    final path = await _localPath;
    return File('$path/$key.jpg').delete();
  }


  /// Opens the image picker and returns the cropped image
  Future<CroppedFile> pickAndCropImage(BuildContext context, {bool onlySquareCrop = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final CroppedFile? croppedFile = await _cropImage(image, context, onlySquareCrop: onlySquareCrop);
      if (croppedFile == null) {
        throw Exception('Image cropping failed');
      }
      return croppedFile;
    } else {
      throw Exception('No image selected');
    }
  }

  Future<CroppedFile?> _cropImage(XFile file, BuildContext context, {bool onlySquareCrop = false}) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: onlySquareCrop ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
      aspectRatioPresets: onlySquareCrop ? [CropAspectRatioPreset.square] : [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Bild zuschneiden',
            toolbarColor: Theme.of(context).colorScheme.white,
            toolbarWidgetColor:  Theme.of(context).colorScheme.black,
            activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: onlySquareCrop,
        ),
        IOSUiSettings(
          title: 'Bild zuschneiden',
          doneButtonTitle: 'Fertig',
          cancelButtonTitle: 'Abbrechen',
        ),
      ],
    );

    return croppedFile;
  }
}