import 'package:flutter/material.dart';

import '../models/music_prompt_result.dart';
import '../models/prompt_model.dart';
import '../services/history_service.dart';
import '../services/openai_service.dart';

class MusicPromptProvider extends ChangeNotifier {
  bool _isLoading = false;
  MusicPromptResult _result = MusicPromptResult.empty();

  bool get isLoading => _isLoading;
  MusicPromptResult get result => _result;

  Future<void> generate(String promptText) async {
    if (promptText.trim().isEmpty) return;

    _isLoading = true;
    _result = MusicPromptResult.empty();
    notifyListeners();

    try {
      final aiResponse = await OpenAIService.generateText(
        'Create a professional AI music prompt based on this description: $promptText',
      );

      _result = MusicPromptResult(
        prompt: aiResponse,
      );

      if (!_result.prompt.startsWith("Error")) {
        await HistoryService.addPrompt(
          PromptModel(
            title: "Music Prompt",
            prompt: _result.prompt,
            createdAt: DateTime.now(),
            isFavorite: false,
          ),
        );
      }
    } catch (e) {
      _result = MusicPromptResult(
        prompt: "Error: ${e.toString()}",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _result = MusicPromptResult.empty();
    _isLoading = false;
    notifyListeners();
  }
}