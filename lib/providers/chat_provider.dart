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

  bool get hasMessages => _messages.isNotEmpty;

  int get messageCount => _messages.length;

  ChatMessage? get lastMessage {
    if (_messages.isEmpty) {
      return null;
    }

    return _messages.last;
  }

  Future<void> sendMessage(String prompt) async {
    if (_isLoading) return;

    final cleanPrompt = prompt.trim();

    if (cleanPrompt.isEmpty) {
      return;
    }

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: cleanPrompt,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    _messages.add(userMessage);

    _isLoading = true;
    _isTyping = true;

    notifyListeners();

    const systemPrompt = '''
You are JB Creator AI.

You are a professional AI assistant for creators.

You help with:
• AI Chat
• YouTube content
• AI Thumbnail
• AI Image prompts
• AI SEO
• AI Lyrics
• AI Scripts
• AI Music prompts
• AI Video prompts

Give clear, professional and useful answers.

When the user requests content, provide ready-to-use content.

Remember the conversation context and avoid unnecessarily repeating
information that has already been established.
''';

    try {
      final conversation = _buildConversationContext();

      final result =
      await OpenAIService.generateConversation(
        conversation,
        systemPrompt: systemPrompt,
      );

      final isError =
          result.startsWith('ERROR:') ||
              result.startsWith('❌') ||
              result.startsWith('⚠️');

      _messages.add(
        ChatMessage(
          id: _uuid.v4(),
          text: result,
          role: MessageRole.assistant,
          createdAt: DateTime.now(),
          isError: isError,
        ),
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('ChatProvider Error: $e');
        debugPrint(stackTrace.toString());
      }

      _messages.add(
        ChatMessage(
          id: _uuid.v4(),
          text: 'ERROR: NETWORK',
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

  /// Builds a compact conversation context.
  ///
  /// Keeping the latest messages prevents the request from becoming
  /// unnecessarily large during a long conversation.
  List<Map<String, String>> _buildConversationContext() {
    const int maxContextMessages = 20;

    final startIndex =
    _messages.length > maxContextMessages
        ? _messages.length - maxContextMessages
        : 0;

    final recentMessages =
    _messages.sublist(startIndex);

    return recentMessages.map((message) {
      return {
        'role': message.role == MessageRole.user
            ? 'user'
            : 'assistant',
        'content': message.text,
      };
    }).toList();
  }

  void clearChat() {
    _messages.clear();

    _isLoading = false;
    _isTyping = false;

    notifyListeners();
  }

  void newChat() {
    clearChat();
  }

  void removeMessage(String id) {
    _messages.removeWhere(
          (message) => message.id == id,
    );

    notifyListeners();
  }

  Future<void> regenerateLast() async {
    if (_isLoading || _messages.isEmpty) {
      return;
    }

    ChatMessage? lastUserMessage;

    for (final message in _messages.reversed) {
      if (message.role == MessageRole.user) {
        lastUserMessage = message;
        break;
      }
    }

    if (lastUserMessage == null) {
      return;
    }

    // Remove the last assistant response.
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i].role == MessageRole.assistant) {
        _messages.removeAt(i);
        break;
      }
    }

    notifyListeners();

    await _regenerateFromExistingUserMessage(
      lastUserMessage.text,
    );
  }

  Future<void> _regenerateFromExistingUserMessage(
      String prompt,
      ) async {
    if (_isLoading) return;

    _isLoading = true;
    _isTyping = true;

    notifyListeners();

    const systemPrompt = '''
You are JB Creator AI.

You are a professional AI assistant for creators.

Provide accurate, clear and professional responses while
maintaining the conversation context.
''';

    try {
      final conversation = _buildConversationContext();

      final result =
      await OpenAIService.generateConversation(
        conversation,
        systemPrompt: systemPrompt,
      );

      final isError =
          result.startsWith('ERROR:') ||
              result.startsWith('❌') ||
              result.startsWith('⚠️');

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
        debugPrint('Regenerate Error: $e');
      }

      _messages.add(
        ChatMessage(
          id: _uuid.v4(),
          text: 'ERROR: NETWORK',
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

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}