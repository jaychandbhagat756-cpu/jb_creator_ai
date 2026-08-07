class MusicPromptResult {
  final String prompt;

  const MusicPromptResult({
    required this.prompt,
  });

  factory MusicPromptResult.empty() {
    return const MusicPromptResult(
      prompt: "",
    );
  }

  bool get isEmpty => prompt.isEmpty;
}