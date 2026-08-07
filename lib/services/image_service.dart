import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ImageService {
  static const Duration timeout = Duration(seconds: 60);

  static final Uri imageApi = Uri.parse(ApiConfig.imageEndpoint);

  static final http.Client _client = http.Client();

  static Map<String, String> get headers => {
    "Authorization": "Bearer ${ApiConfig.apiKey}",
    "Content-Type": "application/json; charset=utf-8",
  };

  static Future<String> generateImage({
    required String prompt,
    String size = "1024x1024",
    String quality = "high",
  }) async {
    if (ApiConfig.apiKey.trim().isEmpty ||
        ApiConfig.apiKey == "YOUR_OPENAI_API_KEY") {
      return "ERROR: API_KEY";
    }

    if (prompt.trim().isEmpty) {
      return "ERROR: EMPTY_PROMPT";
    }

    final body = {
      "model": ApiConfig.imageModel,
      "prompt": prompt,
      "size": size,
      "quality": quality,
    };

    try {
      final response = await _client
          .post(
        imageApi,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(timeout);

      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;

          final data = json["data"];

          if (data is List && data.isNotEmpty) {
            final first = data.first;

            if (first is Map<String, dynamic>) {
              if (first["url"] is String) {
                return first["url"];
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