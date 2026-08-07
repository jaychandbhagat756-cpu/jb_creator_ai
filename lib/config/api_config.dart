class ApiConfig {
  ApiConfig._();

  static const String apiKey = "YOUR_OPENAI_API_KEY";

  static const String baseUrl = "https://api.openai.com/v1";

  static const String chatEndpoint = "$baseUrl/chat/completions";

  static const String imageEndpoint = "$baseUrl/images/generations";

  static const String chatModel = "gpt-5.5";

  static const String imageModel = "gpt-image-1";
}