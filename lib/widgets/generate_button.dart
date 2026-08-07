import 'package:flutter/material.dart';

class GenerateButton extends StatelessWidget {
  const GenerateButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.text = "Generate Thumbnail", // 🎯 डिफ़ॉल्ट टेक्स्ट
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final String text; // 🎯 डायनेमिक टेक्स्ट वेरिएबल

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
              : const Icon(
            Icons.auto_awesome,
          ),
          label: Text(
            isLoading ? "Generating..." : text, // 🎯 लोडिंग के समय "Generating...", वरना custom text
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: FilledButton.styleFrom(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}