import '../models/seo_result.dart';
import '../services/openai_service.dart';

class SEOService {
  SEOService._();

  static Future<SEOResult> generateSEO(String prompt) async {
    if (prompt.trim().isEmpty) {
      return SEOResult.error("Please enter a video topic.");
    }

    final aiPrompt = '''
You are a professional YouTube SEO Expert.

Generate a complete YouTube SEO package in English.

IMPORTANT:
- Follow the exact section labels below.
- Do not add extra section labels.
- Keep each section separate.
- TITLE must be one clickable SEO title.
- DESCRIPTION must be a professional YouTube description.
- TAGS must contain exactly 30 comma-separated tags.
- HASHTAGS must contain exactly 10 hashtags.
- KEYWORDS must contain exactly 20 comma-separated keywords.
- THUMBNAIL must contain one short thumbnail text.
- PINNED COMMENT must contain one professional pinned comment.

Use this exact format:

TITLE:
[SEO optimized clickable title]

DESCRIPTION:
[Professional YouTube description]

TAGS:
[tag 1, tag 2, tag 3, ...]

HASHTAGS:
[#hashtag1 #hashtag2 #hashtag3 ...]

KEYWORDS:
[keyword 1, keyword 2, keyword 3, ...]

THUMBNAIL:
[Short thumbnail text]

PINNED COMMENT:
[Professional pinned comment]

Topic:
$prompt
''';

    final response = await OpenAIService.generateText(aiPrompt);

    if (response.startsWith("ERROR:") ||
        response.startsWith("❌") ||
        response.startsWith("⚠️")) {
      return SEOResult.error(response);
    }

    return _parseResponse(response);
  }

  static SEOResult _parseResponse(String response) {
    final title = _extractSection(
      response,
      'TITLE:',
      'DESCRIPTION:',
    );

    final description = _extractSection(
      response,
      'DESCRIPTION:',
      'TAGS:',
    );

    final tags = _extractSection(
      response,
      'TAGS:',
      'HASHTAGS:',
    );

    final hashtags = _extractSection(
      response,
      'HASHTAGS:',
      'KEYWORDS:',
    );

    final keywords = _extractSection(
      response,
      'KEYWORDS:',
      'THUMBNAIL:',
    );

    final thumbnailText = _extractSection(
      response,
      'THUMBNAIL:',
      'PINNED COMMENT:',
    );

    final pinnedComment = _extractSection(
      response,
      'PINNED COMMENT:',
      null,
    );

    if (title.isEmpty &&
        description.isEmpty &&
        tags.isEmpty &&
        hashtags.isEmpty &&
        keywords.isEmpty &&
        thumbnailText.isEmpty &&
        pinnedComment.isEmpty) {
      return SEOResult.error(
        "⚠️ Unable to read the SEO response. Please try again.",
      );
    }

    return SEOResult(
      title: title,
      description: description,
      tags: tags,
      hashtags: hashtags,
      keywords: keywords,
      thumbnailText: thumbnailText,
      pinnedComment: pinnedComment,
    );
  }

  static String _extractSection(
      String text,
      String startLabel,
      String? endLabel,
      ) {
    final startIndex = text.toUpperCase().indexOf(
      startLabel.toUpperCase(),
    );

    if (startIndex == -1) {
      return "";
    }

    final contentStart = startIndex + startLabel.length;

    if (endLabel == null) {
      return text.substring(contentStart).trim();
    }

    final endIndex = text.toUpperCase().indexOf(
      endLabel.toUpperCase(),
      contentStart,
    );

    if (endIndex == -1) {
      return text.substring(contentStart).trim();
    }

    return text
        .substring(contentStart, endIndex)
        .trim();
  }
}