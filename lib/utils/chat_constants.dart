class ChatConstants {
  ChatConstants._();

  // ==========================
  // App
  // ==========================

  static const String appName = "JB Creator AI";

  // ==========================
  // AI
  // ==========================

  static const String model = "gpt-5.5";

  static const int maxTokens = 2048;

  static const double temperature = 0.7;

  // ==========================
  // Chat Limits
  // ==========================

  static const int maxMessageLength = 4000;

  static const int maxHistory = 100;

  // ==========================
  // Animation
  // ==========================

  static const Duration bubbleAnimation = Duration(
    milliseconds: 250,
  );

  static const Duration typingAnimation = Duration(
    milliseconds: 600,
  );

  static const Duration scrollAnimation = Duration(
    milliseconds: 300,
  );

  // ==========================
  // UI
  // ==========================

  static const double borderRadius = 18;

  static const double messagePadding = 14;

  static const double avatarRadius = 18;

  static const double maxBubbleWidth = 0.78;

  // ==========================
  // Labels
  // ==========================

  static const String typingText = "AI is typing...";

  static const String emptyChat =
      "Start chatting with JB Creator AI";

  static const String inputHint =
      "Ask anything...";

  static const String error =
      "Something went wrong.";

  static const String retry =
      "Retry";

  static const String copy =
      "Copy";

  static const String copied =
      "Copied";

  static const String regenerate =
      "Regenerate";

  static const String delete =
      "Delete";

  static const String clearChat =
      "Clear Chat";

  static const String newChat =
      "New Chat";
}