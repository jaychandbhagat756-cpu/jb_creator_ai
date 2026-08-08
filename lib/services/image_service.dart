import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ImageService {
  ImageService._();

  static const Duration timeout = Duration(seconds: 90);

  static final Uri _imageApi =
  Uri.parse(ApiConfig.imageEndpoint);

  static final http.Client _client = http.Client();

  static Map<String, String> get _headers => {
    'Authorization': 'Bearer ${ApiConfig.apiKey}',
    'Content-Type': 'application/json',
  };

  static Future<String> generateImage({
    required String prompt,
    String size = '1024x1024',
    String quality = 'high',
  }) async {
    final apiKey = ApiConfig.apiKey.trim();

    if (apiKey.isEmpty ||
        apiKey == 'YOUR_OPENAI_API_KEY') {
      return 'ERROR: API_KEY';
    }

    final cleanPrompt = prompt.trim();

    if (cleanPrompt.isEmpty) {
      return 'ERROR: EMPTY_PROMPT';
    }

    final body = <String, dynamic>{
      'model': ApiConfig.imageModel,
      'prompt': cleanPrompt,
      'size': size,
      'quality': quality,
    };

    try {
      final response = await _client
          .post(
        _imageApi,
        headers: _headers,
        body: jsonEncode(body),
      )
          .timeout(timeout);

      if (kDebugMode) {
        debugPrint(
          'Image API status: ${response.statusCode}',
        );
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        return _handleError(response.statusCode);
      }

      final decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (decoded is! Map<String, dynamic>) {
        return 'ERROR: INVALID_RESPONSE';
      }

      final data = decoded['data'];

      if (data is! List || data.isEmpty) {
        return 'ERROR: NO_IMAGE_DATA';
      }

      final first = data.first;

      if (first is! Map<String, dynamic>) {
        return 'ERROR: INVALID_IMAGE_DATA';
      }

      final url = first['url'];

      if (url is String && url.trim().isNotEmpty) {
        return url.trim();
      }

      final b64Json = first['b64_json'];

      if (b64Json is String &&
          b64Json.trim().isNotEmpty) {
        return 'BASE64:$b64Json';
      }

      return 'ERROR: IMAGE_URL_NOT_FOUND';
    } on TimeoutException {
      return 'ERROR: TIMEOUT';
    } on FormatException {
      return 'ERROR: INVALID_JSON';
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'Image generation error: $e',
        );
      }

      return 'ERROR: NETWORK';
    }
  }

  static String _handleError(int statusCode) {
    switch (statusCode) {
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
        return 'ERROR: HTTP_$statusCode';
    }
  }

  static void dispose() {
    _client.close();
  }
}