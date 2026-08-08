import 'dart:convert';

import '../models/seo_result.dart';
import '../services/openai_service.dart';

class SEOService {
  SEOService._();

  static Future<SEOResult> generateSEO(String prompt) async {
    final cleanPrompt = prompt.trim();

    if (cleanPrompt.isEmpty) {
      return SEOResult.empty();
    }

    final aiPrompt = '''
You are a professional YouTube SEO expert working for JB Creator AI.

Create a complete YouTube SEO package for the following video topic:

$cleanPrompt

Return ONLY valid JSON.
Do not use Markdown.
Do not use code fences.
Do not add any explanation before or after the JSON.

Use exactly these keys:

{
  "title": "One highly clickable SEO optimized YouTube title",
  "description": "Professional YouTube description with a strong opening, useful context and natural keywords",
  "tags": "30 comma-separated YouTube tags",
  "hashtags": "10 relevant hashtags separated by spaces",
  "keywords": "20 SEO keywords separated by commas",
  "thumbnailText": "Short powerful thumbnail text, maximum 6 words",
  "pinnedComment": "Professional engaging pinned comment encouraging viewers to interact"
}

Requirements:
- Make the title clickable but not misleading.
- Keep the description natural and professional.
- Provide exactly 30 tags.
- Provide exactly 10 hashtags.
- Provide exactly 20 keywords.
- Thumbnail text must be short and highly readable.
- Pinned comment should encourage comments and engagement.
- Avoid keyword stuffing.
- Do not use fake claims.
- Keep everything relevant to the topic.
''';

    final response = await OpenAIService.generateText(
      aiPrompt,
    );

    if (_isError(response)) {
      return SEOResult.empty();
    }

    return _parseResponse(response);
  }

  static bool _isError(String response) {
    return response.startsWith('ERROR:') ||
        response.startsWith('❌') ||
        response.startsWith('⚠️');
  }

  static SEOResult _parseResponse(String response) {
    try {
      String jsonText = response.trim();

      // Remove Markdown code fences if the model accidentally adds them.
      if (jsonText.startsWith('```')) {
        final firstNewLine = jsonText.indexOf('\n');

        if (firstNewLine != -1) {
          jsonText = jsonText.substring(firstNewLine + 1);
        }

        if (jsonText.endsWith('```')) {
          jsonText =
              jsonText.substring(0, jsonText.length - 3).trim();
        }
      }

      // Find JSON object if the model adds extra text.
      final start = jsonText.indexOf('{');
      final end = jsonText.lastIndexOf('}');

      if (start == -1 || end == -1 || end <= start) {
        return SEOResult.empty();
      }

      jsonText = jsonText.substring(start, end + 1);

      final decoded = jsonDecode(jsonText);

      if (decoded is! Map<String, dynamic>) {
        return SEOResult.empty();
      }

      return SEOResult(
        title: _stringValue(decoded['title']),
        description: _stringValue(decoded['description']),
        tags: _stringValue(decoded['tags']),
        hashtags: _stringValue(decoded['hashtags']),
        keywords: _stringValue(decoded['keywords']),
        thumbnailText: _stringValue(
          decoded['thumbnailText'],
        ),
        pinnedComment: _stringValue(
          decoded['pinnedComment'],
        ),
      );
    } catch (_) {
      return SEOResult.empty();
    }
  }

  static String _stringValue(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }
}