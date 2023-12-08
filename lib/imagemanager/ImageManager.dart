import 'dart:io';
import 'package:flutter/material.dart';
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
      return Image.asset('assets/icons/review_full.png');  // Replace with the actual path of your placeholder image
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

  /// Opens the image picker and returns the picked image
  Future<File> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    } else {
      throw Exception('No image selected');
    }
  }
}