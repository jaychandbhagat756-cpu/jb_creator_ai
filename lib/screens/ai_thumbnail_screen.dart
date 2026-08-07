import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../models/prompt_model.dart';
import '../services/history_service.dart';
import '../services/openai_service.dart';
import '../widgets/generate_button.dart';

class AIThumbnailScreen extends StatefulWidget {
  const AIThumbnailScreen({super.key});

  @override
  State<AIThumbnailScreen> createState() => _AIThumbnailScreenState();
}

class _AIThumbnailScreenState extends State<AIThumbnailScreen> {
  final TextEditingController topicController = TextEditingController();

  String thumbnailStyle = "Vibrant & Modern";
  String colorTone = "High Contrast";

  final List<String> thumbnailStyles = [
    "Vibrant & Modern",
    "Minimalist",
    "Cinematic",
    "Gaming / Esports",
    "Tech & Gadgets",
  ];

  final List<String> colorTones = [
    "High Contrast",
    "Dark & Moody",
    "Bright & Neon",
    "Warm Tones",
    "Cool Tones",
  ];

  String generatedPrompt = "";
  bool isGenerating = false;
  bool isFavorite = false;

  @override
  void dispose() {
    topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Thumbnail Generator"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              topicController.clear();
              setState(() {
                generatedPrompt = "";
                isGenerating = false;
                isFavorite = false;
                thumbnailStyle = "Vibrant & Modern";
                colorTone = "High Contrast";
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Form cleared successfully"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thumbnail Topic / Idea",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: topicController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter your video title or thumbnail concept...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: thumbnailStyle,
              decoration: InputDecoration(
                labelText: "Thumbnail Style",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: thumbnailStyles.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  thumbnailStyle = value!;
                });
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: colorTone,
              decoration: InputDecoration(
                labelText: "Color Tone",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: colorTones.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  colorTone = value!;
                });
              },
            ),
            const SizedBox(height: 25),

            // 🎯 Generate Button
            GenerateButton(
              text: "Generate Thumbnail Prompt",
              isLoading: isGenerating,
              onPressed: isGenerating
                  ? null
                  : () async {
                final messenger = ScaffoldMessenger.of(context);
                FocusScope.of(context).unfocus();

                if (topicController.text.trim().isEmpty) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Please enter topic or idea"),
                    ),
                  );
                  return;
                }

                setState(() {
                  isGenerating = true;
                  generatedPrompt = "";
                  isFavorite = false;
                });

                final prompt = '''
Create a creative and high-CTR YouTube thumbnail prompt/concept.

Topic: ${topicController.text}
Style: $thumbnailStyle
Color Tone: $colorTone

Provide a detailed visual description, text elements, and layout ideas for the thumbnail.
''';

                try {
                  final result = await OpenAIService.generateText(prompt);

                  if (!mounted) return;

                  setState(() {
                    generatedPrompt = result;
                  });

                  if (result.startsWith("ERROR:") ||
                      result.startsWith("❌") ||
                      result.startsWith("⚠️")) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(result)),
                    );
                  } else {
                    // 🎯 Hive में सेव करते समय सीधे isFavorite: false का उपयोग
                    await HistoryService.addPrompt(
                      PromptModel(
                        title: topicController.text,
                        prompt: result,
                        createdAt: DateTime.now(),
                        isFavorite: false,
                      ),
                    );

                    if (!mounted) return;

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Thumbnail concept generated & saved successfully! 🎉",
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      isGenerating = false;
                    });
                  }
                }
              },
            ),

            const SizedBox(height: 20),

            if (generatedPrompt.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Generated Thumbnail Concept",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SelectableText(
                        generatedPrompt,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Favorite, Share & Copy Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final messenger = ScaffoldMessenger.of(context);
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? "Added to Favorites ❤️"
                                          : "Removed from Favorites",
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              label: Text(
                                isFavorite ? "Favorited" : "Favorite",
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await SharePlus.instance.share(
                                  ShareParams(
                                    text: generatedPrompt,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: const Text("Share"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final messenger = ScaffoldMessenger.of(context);
                                await Clipboard.setData(
                                  ClipboardData(text: generatedPrompt),
                                );
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text("Concept copied to clipboard"),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy),
                              label: const Text("Copy"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}