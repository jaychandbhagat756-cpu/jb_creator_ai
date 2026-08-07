import 'package:flutter/foundation.dart';

import '../models/video_prompt_result.dart';
import '../services/video_prompt_service.dart';

class VideoPromptProvider extends ChangeNotifier {
  bool _isLoading = false;

  VideoPromptResult _result = VideoPromptResult.empty();

  String _lastPrompt = "";

  bool get isLoading => _isLoading;

  VideoPromptResult get result => _result;

  bool get hasResult => !_result.isEmpty;

  Future<void> generate(String prompt) async {
    if (prompt.trim().isEmpty) {
      return;
    }

    _lastPrompt = prompt;

    _isLoading = true;
    notifyListeners();

    _result = await VideoPromptService.generate(
      prompt,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> regenerate() async {
    if (_lastPrompt.isEmpty) {
      return;
    }

    await generate(_lastPrompt);
  }

  void clear() {
    _lastPrompt = "";
    _result = VideoPromptResult.empty();

    notifyListeners();
  }
}