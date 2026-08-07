import '../models/video_prompt_result.dart';
import 'openai_service.dart';

class VideoPromptService {
  VideoPromptService._();

  static Future<VideoPromptResult> generate(
      String prompt,
      ) async {
    if (prompt.trim().isEmpty) {
      return VideoPromptResult.empty();
    }

    final aiPrompt = '''
You are a professional AI Video Prompt Engineer.

Create a cinematic prompt for AI video generators.

Include:

• Camera Angle
• Camera Movement
• Subject
• Lighting
• Environment
• Mood
• Color Grading
• Cinematic Style
• Shot Details
• 4K Ultra HD

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
      return VideoPromptResult.empty();
    }

    return VideoPromptResult(
      prompt: result,
    );
  }
}