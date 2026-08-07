import 'package:hive/hive.dart';

part 'prompt_model.g.dart';

@HiveType(typeId: 0)
class PromptModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String prompt;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final bool isFavorite;

  PromptModel({
    required this.title,
    required this.prompt,
    required this.createdAt,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'prompt': prompt,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory PromptModel.fromMap(Map<String, dynamic> map) {
    return PromptModel(
      title: map['title'] ?? '',
      prompt: map['prompt'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  PromptModel copyWith({
    String? title,
    String? prompt,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return PromptModel(
      title: title ?? this.title,
      prompt: prompt ?? this.prompt,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}