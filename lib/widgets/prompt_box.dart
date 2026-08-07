import 'package:flutter/material.dart';

class PromptBox extends StatefulWidget {
  const PromptBox({
    super.key,
    required this.controller,
    required this.maxLength,
    this.hintText, // 🎯 Step 1: Optional hintText पैरामीटर जोड़ा गया
  });

  final TextEditingController controller;
  final int maxLength;
  final String? hintText; // 🎯 Step 2: Variable जोड़ा गया

  @override
  State<PromptBox> createState() => _PromptBoxState();
}

class _PromptBoxState extends State<PromptBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: widget.controller,
              maxLines: 6,
              minLines: 4,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                // 🎯 Step 3: Dynamic hintText का उपयोग, न मिलने पर डिफ़ॉल्ट टेक्स्ट दिखेगा
                hintText: widget.hintText ??
                    "Describe your YouTube thumbnail...\n\nExample:\nA professional Bollywood movie poster with dramatic lighting and cinematic background.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.controller.text.length}/${widget.maxLength}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                TextButton.icon(
                  onPressed: () {
                    widget.controller.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}