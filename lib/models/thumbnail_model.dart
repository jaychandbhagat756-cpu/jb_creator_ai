enum ThumbnailStyle {
  realistic,
  cinematic,
  youtube,
  gaming,
  business,
  anime,
  cartoon,
  minimal,
}

class ThumbnailModel {
  final String prompt;
  final String imageUrl;
  final ThumbnailStyle style;
  final String size;
  final DateTime createdAt;

  const ThumbnailModel({
    required this.prompt,
    required this.imageUrl,
    required this.style,
    required this.size,
    required this.createdAt,
  });

  ThumbnailModel copyWith({
    String? prompt,
    String? imageUrl,
    ThumbnailStyle? style,
    String? size,
    DateTime? createdAt,
  }) {
    return ThumbnailModel(
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      style: style ?? this.style,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}