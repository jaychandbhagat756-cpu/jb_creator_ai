class LyricsResult {
  final String lyrics;

  const LyricsResult({
    required this.lyrics,
  });

  factory LyricsResult.empty() {
    return const LyricsResult(
      lyrics: "",
    );
  }

  bool get isEmpty => lyrics.isEmpty;
}