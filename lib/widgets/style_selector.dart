import 'package:flutter/material.dart';
import '../models/thumbnail_model.dart';

class StyleSelector extends StatelessWidget {
  const StyleSelector({
    super.key,
    required this.selectedStyle,
    required this.selectedSize,
    required this.onStyleChanged,
    required this.onSizeChanged,
  });

  // 💡 Non-nullable Callbacks
  final ValueChanged<ThumbnailStyle> onStyleChanged;
  final ValueChanged<String> onSizeChanged;

  final ThumbnailStyle selectedStyle;
  final String selectedSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thumbnail Style",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          DropdownButtonFormField<ThumbnailStyle>(
            initialValue: selectedStyle,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: ThumbnailStyle.values.map((style) {
              return DropdownMenuItem(
                value: style,
                child: Text(style.name.toUpperCase()),
              );
            }).toList(),
            // 🛡️ Null Safety हैंडलिंग
            onChanged: (value) {
              if (value != null) {
                onStyleChanged(value);
              }
            },
          ),

          const SizedBox(height: 16),

          const Text(
            "Thumbnail Size / Aspect Ratio",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            initialValue: selectedSize,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: "16:9",
                child: Text("16:9 (YouTube Landscape)"),
              ),
              DropdownMenuItem(
                value: "9:16",
                child: Text("9:16 (Shorts / Reels)"),
              ),
              DropdownMenuItem(
                value: "1:1",
                child: Text("1:1 (Square)"),
              ),
            ],
            // 🛡️ Null Safety हैंडलिंग
            onChanged: (value) {
              if (value != null) {
                onSizeChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}