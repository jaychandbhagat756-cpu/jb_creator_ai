import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../services/openai_service.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider();

  final List<ChatMessage> _messages = [];

  final Uuid _uuid = const Uuid();

  bool _isLoading = false;

  bool _isTyping = false;

  List<ChatMessage> get messages =>
      List.unmodifiable(_messages);

  bool get isLoading => _isLoading;

  bool get isTyping => _isTyping;

  Future<void> sendMessage(
      String prompt,
      ) async {
    // 🛡️ Double Send Protection
    if (_isLoading) return;

    if (prompt.trim().isEmpty) {
      return;
    }

    _messages.add(
      ChatMessage(
        id: _uuid.v4(),
        text: prompt.trim(),
        role: MessageRole.user,
        createdAt: DateTime.now(),
      ),
    );

    _isLoading = true;
    _isTyping = true;
    notifyListeners();

    const systemPrompt = '''
You are JB Creator AI.

You help creators with:

• AI Chat
• AI Thumbnail
• AI SEO
• AI Lyrics
• AI Script
• AI Music Prompt
• AI Video Prompt

Always answer clearly and professionally.
''';

    try {
      final result =
      await OpenAIService.generateText(
        "$systemPrompt\n\n${prompt.trim()}",
      );

      // ✨ Improved Error Detection
      final bool isError = result.startsWith("ERROR:") ||
          result.startsWith("❌") ||
          result.startsWith("⚠️");

      _messages.add(
        ChatMessage(
          id: _uuid.v4(),
          text: result,
          role: MessageRole.assistant,
          createdAt: DateTime.now(),
          isError: isError,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      _messages.add(
        ChatMessage(
          id: _uuid.v4(),
          text: "ERROR: NETWORK",
          role: MessageRole.assistant,
          createdAt: DateTime.now(),
          isError: true,
        ),
      );
    } finally {
      _isLoading = false;
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }

  void removeMessage(String id) {
    _messages.removeWhere(
          (message) => message.id == id,
    );

    notifyListeners();
  }

  Future<void> regenerateLast() async {
    if (_messages.isEmpty) {
      return;
    }

    ChatMessage? lastUser;

    for (final message in _messages.reversed) {
      if (message.role == MessageRole.user) {
        lastUser = message;
        break;
      }
    }

    if (lastUser == null) {
      return;
    }

    // केवल आखिरी असिस्टेंट मैसेज को हटाएँ
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i].role == MessageRole.assistant) {
        _messages.removeAt(i);
        break;
      }
    }

    notifyListeners();

    await sendMessage(lastUser.text);
  }

  void newChat() {
    _messages.clear();

    _isLoading = false;
    _isTyping = false;

    notifyListeners();
  }

  ChatMessage? get lastMessage {
    if (_messages.isEmpty) {
      return null;
    }

    return _messages.last;
  }

  bool get hasMessages =>
      _messages.isNotEmpty;

  int get messageCount =>
      _messages.length;

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}