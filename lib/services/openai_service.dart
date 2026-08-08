import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class OpenAIService {
  OpenAIService._();

  static final http.Client _client = http.Client();

  static const String _model = 'gpt-4o-mini';
  static const double _temperature = 0.7;
  static const Duration _timeout = Duration(seconds: 45);

  static String get _apiKey => ApiConfig.apiKey.trim();

  static Uri get _chatUri =>
      Uri.parse('https://api.openai.com/v1/chat/completions');

  static Map<String, String> get _headers => {
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json; charset=utf-8',
  };

  static const String defaultSystemPrompt = '''
You are JB Creator AI, a professional AI assistant for content creators.

You help users with:
• AI Chat
• YouTube content
• AI Thumbnail prompts
• AI Image prompts
• AI Video prompts
• YouTube SEO
• Video scripts
• Lyrics
• Music prompts
• Creative writing

Always provide clear, useful, professional and well-structured answers.

When the user asks for content, give ready-to-use content whenever possible.

Do not unnecessarily repeat the user's question.
''';

  static bool get hasValidApiKey {
    if (_apiKey.isEmpty) return false;
    if (_apiKey == 'YOUR_OPENAI_API_KEY') return false;
    if (_apiKey.contains('YOUR_ACTUAL_OPENAI_API_KEY')) {
      return false;
    }

    return _apiKey.startsWith('sk-');
  }

  /// Simple text generation.
  ///
  /// Existing screens can continue using this method.
  static Future<String> generateText(
      String prompt, {
        String? systemPrompt,
      }) async {
    if (prompt.trim().isEmpty) {
      return 'ERROR: EMPTY_PROMPT';
    }

    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content':
        systemPrompt?.trim().isNotEmpty == true
            ? systemPrompt!.trim()
            : defaultSystemPrompt,
      },
      {
        'role': 'user',
        'content': prompt.trim(),
      },
    ];

    return generateConversation(messages);
  }

  /// Professional conversation API.
  ///
  /// This sends the previous relevant messages to OpenAI so the
  /// AI can understand conversation context.
  static Future<String> generateConversation(
      List<Map<String, String>> messages, {
        String? systemPrompt,
      }) async {
    if (!hasValidApiKey) {
      return 'ERROR: API_KEY';
    }

    if (messages.isEmpty) {
      return 'ERROR: EMPTY_PROMPT';
    }

    final List<Map<String, String>> finalMessages = [];

    finalMessages.add({
      'role': 'system',
      'content':
      systemPrompt?.trim().isNotEmpty == true
          ? systemPrompt!.trim()
          : defaultSystemPrompt,
    });

    for (final message in messages) {
      final role = message['role'];
      final content = message['content'];

      if (role == null || content == null) {
        continue;
      }

      if (content.trim().isEmpty) {
        continue;
      }

      if (role != 'user' && role != 'assistant') {
        continue;
      }

      finalMessages.add({
        'role': role,
        'content': content.trim(),
      });
    }

    if (finalMessages.length <= 1) {
      return 'ERROR: EMPTY_PROMPT';
    }

    final requestBody = {
      'model': _model,
      'messages': finalMessages,
      'temperature': _temperature,
    };

    try {
      final response = await _client
          .post(
        _chatUri,
        headers: _headers,
        body: jsonEncode(requestBody),
      )
          .timeout(_timeout);

      return _parseResponse(response);
    } on TimeoutException {
      return 'ERROR: TIMEOUT';
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('OpenAI Service Error: $e');
        debugPrint(stackTrace.toString());
      }

      return 'ERROR: NETWORK';
    }
  }

  static String _parseResponse(http.Response response) {
    final responseText =
    utf8.decode(response.bodyBytes, allowMalformed: true);

    if (response.statusCode != 200) {
      if (kDebugMode) {
        debugPrint(
          'OpenAI API ${response.statusCode}: $responseText',
        );
      }

      switch (response.statusCode) {
        case 400:
          return 'ERROR: BAD_REQUEST';

        case 401:
          return 'ERROR: INVALID_API_KEY';

        case 403:
          return 'ERROR: ACCESS_DENIED';

        case 404:
          return 'ERROR: API_NOT_FOUND';

        case 429:
          return 'ERROR: BILLING_OR_RATE_LIMIT';

        case 500:
        case 501:
        case 502:
        case 503:
        case 504:
          return 'ERROR: SERVER';

        default:
          return 'ERROR: UNKNOWN';
      }
    }

    try {
      final decoded = jsonDecode(responseText);

      if (decoded is! Map<String, dynamic>) {
        return 'ERROR: INVALID_RESPONSE';
      }

      final choices = decoded['choices'];

      if (choices is! List || choices.isEmpty) {
        return 'ERROR: INVALID_RESPONSE';
      }

      final firstChoice = choices.first;

      if (firstChoice is! Map<String, dynamic>) {
        return 'ERROR: INVALID_RESPONSE';
      }

      final message = firstChoice['message'];

      if (message is! Map<String, dynamic>) {
        return 'ERROR: INVALID_RESPONSE';
      }

      final content = message['content'];

      if (content is String && content.trim().isNotEmpty) {
        return content.trim();
      }

      return 'ERROR: INVALID_RESPONSE';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('OpenAI JSON Parse Error: $e');
      }

      return 'ERROR: INVALID_RESPONSE';
    }
  }

  static void dispose() {
    _client.close();
  }
}