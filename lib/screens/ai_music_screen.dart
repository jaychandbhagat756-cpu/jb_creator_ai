import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/music_prompt_provider.dart';
import '../widgets/prompt_box.dart';
import '../widgets/generate_button.dart';
import '../widgets/music_prompt_result_card.dart';

class AIMusicScreen extends StatefulWidget {
  const AIMusicScreen({super.key});

  @override
  State<AIMusicScreen> createState() => _AIMusicScreenState();
}

class _AIMusicScreenState extends State<AIMusicScreen> {
  final TextEditingController _controller =
  TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPromptProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "AI Music Prompt",
            ),
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
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  // 🎯 यहाँ PromptBox में hintText जोड़ दिया गया है
                  PromptBox(
                    controller: _controller,
                    maxLength: 1000,
                    hintText:
                    "Describe your song...\n\nExample:\nA romantic 90s Bollywood song in the style of Kumar Sanu with rain, emotional lyrics and soft piano.",
                  ),

                  // 🎯 यहाँ text: "Generate Music Prompt" और onPressed को अपडेट कर दिया गया है
                  GenerateButton(
                    text: "Generate Music Prompt",
                    isLoading: provider.isLoading,
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                      await provider.generate(
                        _controller.text,
                      );
                    },
                  ),

                  MusicPromptResultCard(
                    result: provider.result,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}