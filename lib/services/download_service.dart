import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadService {
  static Future<File?> downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode != 200) {
        return null;
      }

      final directory = await getTemporaryDirectory();

      final file = File(
        "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png",
      );

      await file.writeAsBytes(response.bodyBytes);

      return file;
    } catch (e) {
      return null;
    }
  }
}