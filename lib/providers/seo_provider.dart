import 'package:flutter/foundation.dart';

// 🎯 ज़रूरी Imports (History के लिए)
import '../models/prompt_model.dart';
import '../services/history_service.dart';

import '../models/seo_result.dart';
import '../services/seo_service.dart';

class SEOProvider extends ChangeNotifier {
  bool _isLoading = false;

  SEOResult _result = SEOResult.empty();

  String _lastPrompt = "";

  bool get isLoading => _isLoading;

  SEOResult get result => _result;

  Future<void> generate(
      String prompt,
      ) async {
    if (prompt.trim().isEmpty) return;

    _lastPrompt = prompt;

    _isLoading = true;
    notifyListeners();

    _result = await SEOService.generateSEO(
      prompt,
    );

    // 🎯 Save to History
    if (!_result.isEmpty) {
      await HistoryService.addPrompt(
        PromptModel(
          title: "SEO Prompt",
          prompt: '''
Title:
${_result.title}

Description:
${_result.description}

Tags:
${_result.tags}
''',
          createdAt: DateTime.now(),
          isFavorite: false,
        ),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> regenerate() async {
    if (_lastPrompt.isEmpty) return;

    await generate(_lastPrompt);
  }

  void clear() {
    _lastPrompt = "";
    _result = SEOResult.empty();

    notifyListeners();
  }

  bool get hasResult =>
      !_result.isEmpty;
}