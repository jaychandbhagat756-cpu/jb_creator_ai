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
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generate(MusicPromptProvider provider) async {
    FocusScope.of(context).unfocus();

    final prompt = _controller.text.trim();

    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe your song first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await provider.generate(prompt);
  }

  void _clear(MusicPromptProvider provider) {
    provider.clear();
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPromptProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Music Prompt'),
            centerTitle: true,
            actions: [
              IconButton(
                tooltip: 'Clear',
                icon: const Icon(Icons.delete_outline),
                onPressed: provider.isLoading
                    ? null
                    : () => _clear(provider),
              ),
            ],
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create Professional Music Prompts',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Describe your song and generate a detailed prompt '
                        'for AI music generators like Suno AI and Udio.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 20),

                  PromptBox(
                    controller: _controller,
                    maxLength: 1000,
                    hintText:
                    'Describe your song...\n\n'
                        'Example:\n'
                        'A romantic 90s Bollywood song with emotional '
                        'lyrics, soft piano, flute, warm strings and '
                        'male vocals.',
                  ),

                  const SizedBox(height: 16),

                  GenerateButton(
                    text: provider.isLoading
                        ? 'Generating...'
                        : 'Generate Music Prompt',
                    isLoading: provider.isLoading,
                    onPressed: provider.isLoading
                        ? null
                        : () => _generate(provider),
                  ),

                  const SizedBox(height: 24),

                  if (provider.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
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