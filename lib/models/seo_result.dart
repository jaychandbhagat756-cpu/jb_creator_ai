class SEOResult {
  final String title;
  final String description;
  final String tags;
  final String hashtags;
  final String keywords;
  final String thumbnailText;
  final String pinnedComment;

  const SEOResult({
    required this.title,
    required this.description,
    required this.tags,
    required this.hashtags,
    required this.keywords,
    required this.thumbnailText,
    required this.pinnedComment,
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
    );
  }

  bool get isEmpty =>
      title.isEmpty &&
          description.isEmpty &&
          tags.isEmpty &&
          hashtags.isEmpty &&
          keywords.isEmpty &&
          thumbnailText.isEmpty &&
          pinnedComment.isEmpty;
}