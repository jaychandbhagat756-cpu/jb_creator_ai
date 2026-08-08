import 'package:flutter/foundation.dart';

import '../models/prompt_model.dart';
import '../models/seo_result.dart';
import '../services/history_service.dart';
import '../services/seo_service.dart';

class SEOProvider extends ChangeNotifier {
  bool _isLoading = false;

  SEOResult _result = SEOResult.empty();

  String _lastPrompt = '';

  bool get isLoading => _isLoading;

  SEOResult get result => _result;

  bool get hasResult => !_result.isEmpty;

  Future<void> generate(String prompt) async {
    final cleanPrompt = prompt.trim();

    if (cleanPrompt.isEmpty || _isLoading) {
      return;
    }

    _lastPrompt = cleanPrompt;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await SEOService.generateSEO(
        cleanPrompt,
      );

      _result = result;

      if (!result.isEmpty) {
        await HistoryService.addPrompt(
          PromptModel(
            title: 'SEO • $cleanPrompt',
            prompt: _historyText(result),
            createdAt: DateTime.now(),
            isFavorite: false,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SEOProvider error: $e');
      }

      _result = SEOResult.empty();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> regenerate() async {
    if (_lastPrompt.isEmpty || _isLoading) {
      return;
    }

    await generate(_lastPrompt);
  }

  void clear() {
    _lastPrompt = '';
    _result = SEOResult.empty();

    notifyListeners();
  }

  String _historyText(SEOResult result) {
    return '''
TITLE:
${result.title}

DESCRIPTION:
${result.description}

TAGS:
${result.tags}

HASHTAGS:
${result.hashtags}

KEYWORDS:
${result.keywords}

THUMBNAIL TEXT:
${result.thumbnailText}

PINNED COMMENT:
${result.pinnedComment}
'''.trim();
  }
}