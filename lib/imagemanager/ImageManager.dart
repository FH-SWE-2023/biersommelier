import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';

class ImageManager {
  /// Returns the local path of the app
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Returns the image with the given [key]
  Future<File> getImageByKey(String key) async {
    final path = await _localPath;
    return File('$path/$key.jpg');
  }

  /// Saves the given [image] and returns the generated key
  Future<String> saveImage(File image) async {
    final path = await _localPath;
    const uuid = Uuid();
    String key = uuid.v1();
    await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/$key.jpg',
    );
    return key;
  }
}