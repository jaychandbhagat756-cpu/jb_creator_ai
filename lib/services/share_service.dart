import 'dart:io';

import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareImage(File imageFile) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imageFile.path)],
          text: "Generated with JB Creator AI",
        ),
      );
    } catch (_) {
      // Share failed
    }
  }
}