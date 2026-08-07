import '../models/music_prompt_result.dart';
import 'openai_service.dart';

class MusicPromptService {
  MusicPromptService._();

  static Future<MusicPromptResult> generate(
      String prompt,
      ) async {
    if (prompt.trim().isEmpty) {
      return MusicPromptResult.empty();
    }

    final aiPrompt = '''
You are a professional AI Music Prompt Engineer.

Create a highly detailed prompt for AI music generators like Suno AI and Udio.

Include:

• Genre
• Mood
• Instruments
• Vocal Style
• Tempo
• Atmosphere
• Mixing Style
• Mastering Style

Topic:

$prompt
''';

    final result =
    await OpenAIService.generateText(
      aiPrompt,
    );

    if (result.startsWith("ERROR:") ||
        result.startsWith("❌") ||
        result.startsWith("⚠️")) {
      return MusicPromptResult.empty();
    }

    return MusicPromptResult(
      prompt: result,
    );
  }
}