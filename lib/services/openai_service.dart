import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // debugPrint और kDebugMode के लिए
import 'package:http/http.dart' as http;

class OpenAIService {
  // 🔑 1. API Key (⚠️ महत्वपूर्ण: प्ले स्टोर पर रिलीज़ करने से पहले इसे .env या अपने Backend से लोड करें)
  static const String apiKey = "YOUR_ACTUAL_OPENAI_API_KEY_HERE";

  // 🌐 2. Base URL & Endpoints (💡 भविष्य में इमेज या अन्य APIs आसानी से जोड़ने के लिए)
  static const String baseUrl = "https://api.openai.com/v1";
  static final Uri baseUri = Uri.parse("$baseUrl/chat/completions");

  // 🤖 3. Model Constant
  static const String model = "gpt-4o-mini";

  // 🌡️ 4. Temperature Constant
  static const double temperature = 0.7;

  // ⏱️ 5. Request Timeout Constant
  static const Duration requestTimeout = Duration(seconds: 30);

  // 💬 6. System Prompt Constant
  static const String systemPrompt =
      "You are JB Creator AI, a professional AI assistant for YouTube creators, music creators, thumbnail design, image prompts, video prompts, SEO, scripts and lyrics. Provide clean, highly optimized, professional, and structured results.";

  // ⚡ 7. Persistent HTTP Client
  static final http.Client _client = http.Client();

  // 🧹 8. Dispose Method (⚠️ इसे केवल ऐप बंद होने पर कॉल करें)
  static void dispose() {
    _client.close();
  }

  // 📋 9. Common Headers Getter
  static Map<String, String> get headers => {
    "Authorization": "Bearer $apiKey",
    "Content-Type": "application/json; charset=utf-8",
  };

  // 🚀 General Text, Lyrics, SEO, Thumbnail & Image Prompts के लिए मास्टर फंक्शन
  static Future<String> generateText(String prompt) async {
    // 🛡️ 1. API Key Validation Check
    if (apiKey.trim().isEmpty ||
        apiKey == "YOUR_ACTUAL_OPENAI_API_KEY_HERE" ||
        !apiKey.startsWith("sk-")) {
      return "❌ OpenAI API Key is missing or invalid.";
    }

    // 🛡️ 2. Prompt Validation Check
    if (prompt.trim().isEmpty) {
      return "❌ Prompt cannot be empty.";
    }

    // 💬 3. Structured Messages List
    final List<Map<String, String>> messages = [
      {
        "role": "system",
        "content": systemPrompt,
      },
      {
        "role": "user",
        "content": prompt,
      }
    ];

    // 📦 4. Request Body
    final requestBodyMap = {
      "model": model,
      "messages": messages,
      "temperature": temperature,
    };

    try {
      final response = await _client
          .post(
        baseUri,
        headers: headers,
        body: jsonEncode(requestBodyMap),
      )
          .timeout(requestTimeout);

      // 🔄 Status Code Handling
      switch (response.statusCode) {
        case 200:
          final String responseString = utf8.decode(response.bodyBytes);
          final dynamic decodedData = jsonDecode(responseString);

          if (decodedData is! Map<String, dynamic>) {
            return "⚠️ Invalid response from OpenAI.";
          }

          final Map<String, dynamic> data = decodedData;

          // 🛡️ 5. Safe Nested JSON Parsing
          final List<dynamic>? choices = data["choices"] as List<dynamic>?;
          if (choices != null && choices.isNotEmpty) {
            final firstChoice = choices.first;

            if (firstChoice is Map<String, dynamic>) {
              final message = firstChoice["message"];

              if (message is Map<String, dynamic>) {
                final content = message["content"];

                if (content is String) {
                  return content.trim();
                }
              }
            }
          }
          return "⚠️ Unexpected response format from OpenAI.";

        case 400:
          return "⚠️ Invalid request sent to OpenAI.";

        case 401:
          return "❌ Invalid OpenAI API Key. Please check your key.";

        case 403:
          return "❌ Access denied. Check your API permissions.";

        case 404:
          return "⚠️ OpenAI endpoint not found.";

        case 429:
          return "⚠️ Rate limit reached or billing unavailable. Please check your OpenAI usage and billing.";

        case 500:
        case 501:
        case 502:
        case 503:
        case 504:
          return "⚠️ OpenAI server is temporarily unavailable. Please try again later.";

        default:
          if (kDebugMode) {
            debugPrint("❌ OpenAI API Error Response (${response.statusCode}): ${response.body}");
          }
          return "⚠️ Request failed (${response.statusCode})\n${response.body}";
      }
    } on TimeoutException {
      return "⚠️ Request timed out. Please check your internet connection and try again.";
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint("❌ OpenAI Service Error: $e");
        debugPrint(stackTrace.toString());
      }
      return "⚠️ Unable to connect. Please check your internet connection.";
    }
  }

// 💡 आने वाले फीचर्स के लिए Placeholders
// static Future<String> generateImage(String imagePrompt) async {
//   // Uri.parse("$baseUrl/images/generations") का उपयोग करके भविष्य में जोड़ सकते हैं
//   return "";
// }
}