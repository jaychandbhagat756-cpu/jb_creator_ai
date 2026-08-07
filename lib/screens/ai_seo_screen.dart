import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/seo_provider.dart';
import '../widgets/prompt_box.dart';
import '../widgets/generate_button.dart';
import '../widgets/seo_result_card.dart';

class AISEOScreen extends StatefulWidget {
  const AISEOScreen({super.key});

  @override
  State<AISEOScreen> createState() => _AISEOScreenState();
}

class _AISEOScreenState extends State<AISEOScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SEOProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("AI SEO Generator"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  provider.clear();
                  _controller.clear();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                PromptBox(
                  controller: _controller,
                  maxLength: 1000,
                  hintText:
                  "Enter your video topic...\n\nExample:\nHow to Grow a YouTube Channel in 2026",
                ),

                // 🎯 यहाँ text: "Generate SEO" जोड़ दिया गया है
                GenerateButton(
                  text: "Generate SEO",
                  isLoading: provider.isLoading,
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                    await provider.generate(
                      _controller.text,
                    );
                  },
                ),

                SEOResultCard(
                  result: provider.result,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}