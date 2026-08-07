import 'package:flutter/foundation.dart';

import '../models/thumbnail_model.dart';
import '../services/thumbnail_service.dart';

class ThumbnailProvider extends ChangeNotifier {
  ThumbnailProvider();

  bool _isLoading = false;

  String _imageUrl = "";

  String _lastPrompt = "";

  ThumbnailStyle _style =
      ThumbnailStyle.youtube;

  // 🎯 यहाँ "1024x1024" को बदलकर "16:9" कर दिया गया है
  String _size = "16:9";

  bool get isLoading => _isLoading;

  String get imageUrl => _imageUrl;

  String get lastPrompt => _lastPrompt;

  ThumbnailStyle get style => _style;

  String get size => _size;

  Future<void> generate(
      String prompt,
      ) async {
    if (prompt.trim().isEmpty) {
      return;
    }

    _isLoading = true;
    _lastPrompt = prompt;

    notifyListeners();

    final result =
    await ThumbnailService
        .generateThumbnail(
      prompt: prompt,
      style: _style,
      size: _size,
    );

    _imageUrl = result;

    _isLoading = false;

    notifyListeners();
  }

  Future<void> regenerate() async {
    if (_lastPrompt.isEmpty) {
      return;
    }

    await generate(_lastPrompt);
  }

  void setStyle(
      ThumbnailStyle value,
      ) {
    _style = value;
    notifyListeners();
  }

  void setSize(
      String value,
      ) {
    _size = value;
    notifyListeners();
  }

  void clear() {
    _imageUrl = "";
    _lastPrompt = "";

    notifyListeners();
  }

  bool get hasImage =>
      _imageUrl.isNotEmpty &&
          !_imageUrl.startsWith("ERROR:");
}