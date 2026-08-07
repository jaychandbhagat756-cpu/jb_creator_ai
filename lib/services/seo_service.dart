import '../services/openai_service.dart';
import '../models/seo_result.dart';

class SEOService {
  SEOService._();

  static Future<SEOResult> generateSEO(
      String prompt,
      ) async {
    if (prompt.trim().isEmpty) {
      return SEOResult.empty();
    }

    final aiPrompt = '''
You are a professional YouTube SEO Expert.

Generate the following in English.

TITLE:
SEO optimized clickable title.

DESCRIPTION:
Professional YouTube description.

TAGS:
30 comma separated SEO tags.

HASHTAGS:
10 trending hashtags.

KEYWORDS:
20 SEO keywords.

THUMBNAIL:
One short thumbnail text.

PINNED COMMENT:
Professional pinned comment.

Topic:

$prompt
''';

    final response =
    await OpenAIService.generateText(
      aiPrompt,
    );

    if (response.startsWith("ERROR:") ||
        response.startsWith("❌") ||
        response.startsWith("⚠️")) {
      return SEOResult.empty();
    }

    return SEOResult(
      title: response,
      description: "",
      tags: "",
      hashtags: "",
      keywords: "",
      thumbnailText: "",
      pinnedComment: "",
    );
  }
}