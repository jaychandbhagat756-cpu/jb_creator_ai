import 'dart:io';

import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryService {
  static Future<bool> saveImage(File imageFile) async {
    try {
      // Storage Permission
      final permission = await Permission.storage.request();

      if (!permission.isGranted) {
        return false;
      }

      final result = await ImageGallerySaverPlus.saveFile(
        imageFile.path,
        name: "JB_Creator_AI_${DateTime.now().millisecondsSinceEpoch}",
      );

      return result["isSuccess"] == true;
    } catch (e) {
      return false;
    }
  }
}