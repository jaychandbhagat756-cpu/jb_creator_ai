import 'package:flutter/material.dart';

import '../models/lyrics_result.dart';

class LyricsResultCard extends StatelessWidget {
  const LyricsResultCard({
    super.key,
    required this.result,
  });

  final LyricsResult result;

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Generated Lyrics",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 24),
              SelectableText(
                result.lyrics,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}