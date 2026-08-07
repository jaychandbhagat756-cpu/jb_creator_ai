import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../widgets/chat_appbar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/typing_indicator.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 🛡️ Scroll Safety सुधार
      if (!_scrollController.hasClients ||
          !_scrollController.position.hasContentDimensions) {
        return;
      }

      try {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Scroll error: $e");
        }
      }
    });
  }

  Future<void> _refreshChat() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: ChatAppBar(
            onNewChat: () => provider.newChat(),
            onClearChat: () => provider.clearChat(),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: provider.hasMessages
                      ? _buildChatList(provider)
                      : _buildEmptyState(),
                ),
                const Divider(height: 1),
                MessageInput(
                  isLoading: provider.isLoading,
                  onSend: (text) async {
                    await provider.sendMessage(text);
                    _scrollToBottom();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to JB Creator AI",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Ask anything.\nGenerate content.\nBoost your creativity.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(ChatProvider provider) {
    return RefreshIndicator(
      onRefresh: _refreshChat,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: 20,
        ),
        itemCount: provider.messages.length + (provider.isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= provider.messages.length) {
            return const TypingIndicator();
          }

          return ChatBubble(
            message: provider.messages[index],
          );
        },
      ),
    );
  }
}