import 'package:hive/hive.dart';
import '../models/prompt_model.dart';

class HistoryService {
  static const String _boxName = 'history';

  static Box<PromptModel> get _box =>
      Hive.box<PromptModel>(_boxName);

  static List<PromptModel> getHistory() {
    return _box.values.toList().reversed.toList();
  }

  static List<PromptModel> getFavorites() {
    return _box.values
        .where((item) => item.isFavorite)
        .toList()
        .reversed
        .toList();
  }

  static Future<void> addPrompt(
      PromptModel prompt,
      ) async {
    await _box.add(prompt);
  }

  static Future<void> clearHistory() async {
    await _box.clear();
  }

  static Future<void> deletePromptByItem(
      PromptModel item,
      ) async {
    final index = _box.values.toList().indexOf(item);

    if (index != -1) {
      await _box.deleteAt(index);
    }
  }

  static Future<void> toggleFavoriteByItem(
      PromptModel item,
      ) async {
    final index = _box.values.toList().indexOf(item);

    if (index == -1) return;

    final updated = item.copyWith(
      isFavorite: !item.isFavorite,
    );

    await _box.putAt(index, updated);
  }
}