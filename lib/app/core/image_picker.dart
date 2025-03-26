import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerService {
  static Future<String?> pickImage() async {
    var xf = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
    );
    return xf?.path;
  }

  static Future<String?> saveImageToPermanentStorage(
    String cacheImagePath,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = cacheImagePath.split('/').last; // Extract filename
    final newPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}$fileName'; // New path

    final File newFile = await File(cacheImagePath).copy(newPath);
    try {
      await File(cacheImagePath).delete();
    } catch (e) {
      print(e.toString());
    }

    return newFile.path; // Return the new file path
  }
}
