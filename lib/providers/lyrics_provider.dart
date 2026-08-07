import 'package:flutter/foundation.dart';

import '../models/lyrics_result.dart';
import '../services/lyrics_service.dart';

class LyricsProvider extends ChangeNotifier {
  bool _isLoading = false;

  LyricsResult _result = LyricsResult.empty();

  String _lastPrompt = "";

  bool get isLoading => _isLoading;

  LyricsResult get result => _result;

  bool get hasResult => !_result.isEmpty;

  Future<void> generate(String prompt) async {
    if (prompt.trim().isEmpty) {
      return;
    }

    _lastPrompt = prompt;

    _isLoading = true;
    notifyListeners();

    _result = await LyricsService.generateLyrics(
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
    _result = LyricsResult.empty();

    notifyListeners();
  }
}