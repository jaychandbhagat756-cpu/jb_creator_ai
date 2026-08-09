import 'package:flutter/material.dart';

import '../models/seo_result.dart';

class SEOResultCard extends StatelessWidget {
  const SEOResultCard({
    super.key,
    required this.result,
  });

  final SEOResult result;

  Widget _section(
      String title,
      String value,
      ) {
    if (value.trim().isEmpty) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SelectableText(
              value,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) {
      return const SizedBox();
    }

    if (result.isError) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SelectableText(
                  result.error,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _section("SEO Title", result.title),
          _section("Description", result.description),
          _section("Tags", result.tags),
          _section("Hashtags", result.hashtags),
          _section("Keywords", result.keywords),
          _section("Thumbnail Text", result.thumbnailText),
          _section("Pinned Comment", result.pinnedComment),
        ],
      ),
    );
  }
}