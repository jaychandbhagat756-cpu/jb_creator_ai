class VideoPromptResult {
  final String prompt;

  const VideoPromptResult({
    required this.prompt,
  });

  factory VideoPromptResult.empty() {
    return const VideoPromptResult(
      prompt: "",
    );
  }

  bool get isEmpty => prompt.isEmpty;
}