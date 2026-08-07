import '../models/lyrics_result.dart';
import 'openai_service.dart';

class LyricsService {
  LyricsService._();

  static Future<LyricsResult> generateLyrics(
      String prompt,
      ) async {
    if (prompt.trim().isEmpty) {
      return LyricsResult.empty();
    }

    final aiPrompt = '''
You are a professional songwriter.

Write complete, original, high-quality song lyrics.

Requirements:

• Intro
• Verse 1
• Chorus
• Verse 2
• Bridge
• Final Chorus
• Outro

Topic:

$prompt
''';

    final response = await OpenAIService.generateText(
      aiPrompt,
    );

    if (response.startsWith("ERROR:") ||
        response.startsWith("❌") ||
        response.startsWith("⚠️")) {
      return LyricsResult.empty();
    }

    return LyricsResult(
      lyrics: response,
    );
  }
}