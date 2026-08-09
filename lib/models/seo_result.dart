class SEOResult {
  final String title;
  final String description;
  final String tags;
  final String hashtags;
  final String keywords;
  final String thumbnailText;
  final String pinnedComment;
  final String error;

  const SEOResult({
    required this.title,
    required this.description,
    required this.tags,
    required this.hashtags,
    required this.keywords,
    required this.thumbnailText,
    required this.pinnedComment,
    this.error = "",
  });

  factory SEOResult.empty() {
    return const SEOResult(
      title: "",
      description: "",
      tags: "",
      hashtags: "",
      keywords: "",
      thumbnailText: "",
      pinnedComment: "",
      error: "",
    );
  }

  factory SEOResult.error(String message) {
    return SEOResult(
      title: "",
      description: "",
      tags: "",
      hashtags: "",
      keywords: "",
      thumbnailText: "",
      pinnedComment: "",
      error: message,
    );
  }

  bool get isError => error.trim().isNotEmpty;

  bool get isEmpty =>
      title.isEmpty &&
          description.isEmpty &&
          tags.isEmpty &&
          hashtags.isEmpty &&
          keywords.isEmpty &&
          thumbnailText.isEmpty &&
          pinnedComment.isEmpty &&
          error.isEmpty;
}