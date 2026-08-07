import 'package:flutter/material.dart';

import '../models/video_prompt_result.dart';

class VideoPromptResultCard extends StatelessWidget {
  const VideoPromptResultCard({
    super.key,
    required this.result,
  });

  final VideoPromptResult result;

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "AI Video Prompt",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(height: 24),

              SelectableText(
                result.prompt,
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