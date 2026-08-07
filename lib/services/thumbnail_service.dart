import 'dart:async';

import 'image_service.dart';
import '../models/thumbnail_model.dart';

class ThumbnailService {
  ThumbnailService._();

  static Future<String> generateThumbnail({
    required String prompt,
    required ThumbnailStyle style,
    String size = "1024x1024",
  }) async {
    if (prompt.trim().isEmpty) {
      return "ERROR: EMPTY_PROMPT";
    }

    final fullPrompt = '''
Create a professional YouTube thumbnail.

Style: ${style.name}

Requirements:

• Ultra HD
• Highly Detailed
• Eye Catching
• Professional Lighting
• High Contrast
• Vibrant Colors
• Cinematic Quality
• Modern Composition
• Sharp Focus
• Click Worthy

User Prompt:

$prompt
''';

    try {
      final result = await ImageService.generateImage(
        prompt: fullPrompt,
        size: size,
        quality: "high",
      );

      return result;
    } on TimeoutException {
      return "ERROR: TIMEOUT";
    } catch (_) {
      return "ERROR: UNKNOWN";
    }
  }
}