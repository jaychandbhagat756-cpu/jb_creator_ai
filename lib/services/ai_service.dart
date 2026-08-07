import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class AIService {
  AIService._();

  static final http.Client _client = http.Client();

  static const Duration timeout = Duration(seconds: 60);

  static Uri get _chatUri =>
      Uri.parse(ApiConfig.chatEndpoint);

  static Map<String, String> get _headers => {
    "Authorization":
    "Bearer ${ApiConfig.apiKey}",
    "Content-Type":
    "application/json; charset=utf-8",
  };

  static Future<String> generate({
    required String systemPrompt,
    required String userPrompt,
    double temperature = 0.7,
    int maxTokens = 2048,
  }) async {

    if (ApiConfig.apiKey.trim().isEmpty ||
        ApiConfig.apiKey ==
            "YOUR_OPENAI_API_KEY") {
      return "ERROR: API_KEY";
    }

    if (userPrompt.trim().isEmpty) {
      return "ERROR: EMPTY_PROMPT";
    }

    final body = {
      "model": ApiConfig.chatModel,
      "messages": [
        {
          "role": "system",
          "content": systemPrompt,
        },
        {
          "role": "user",
          "content": userPrompt,
        }
      ],
      "temperature": temperature,
      "max_completion_tokens": maxTokens,
    };

    try {

      final response = await _client
          .post(
        _chatUri,
        headers: _headers,
        body: jsonEncode(body),
      )
          .timeout(timeout);

      switch (response.statusCode) {

        case 200:

          final json =
          jsonDecode(
            utf8.decode(response.bodyBytes),
          ) as Map<String, dynamic>;

          final choices = json["choices"];

          if (choices is List &&
              choices.isNotEmpty) {

            final first = choices.first;

            if (first is Map<String, dynamic>) {

              final message =
              first["message"];

              if (message is Map<String, dynamic>) {

                final content =
                message["content"];

                if (content is String &&
                    content.trim().isNotEmpty) {

                  return content.trim();

                }

              }

            }

          }

          return "ERROR: INVALID_RESPONSE";

        case 400:
          return "ERROR: BAD_REQUEST";

        case 401:
          return "ERROR: INVALID_API_KEY";

        case 403:
          return "ERROR: ACCESS_DENIED";

        case 404:
          return "ERROR: API_NOT_FOUND";

        case 429:
          return "ERROR: BILLING";

        case 500:
        case 501:
        case 502:
        case 503:
        case 504:
          return "ERROR: SERVER";

        default:

          if (kDebugMode) {
            debugPrint(response.body);
          }

          return "ERROR: UNKNOWN";

      }

    } on TimeoutException {

      return "ERROR: TIMEOUT";

    } catch (e) {

      if (kDebugMode) {
        debugPrint(e.toString());
      }

      return "ERROR: NETWORK";

    }

  }

}