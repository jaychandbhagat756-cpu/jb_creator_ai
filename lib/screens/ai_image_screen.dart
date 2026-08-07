import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

// 🎯 मानक Widgets के Imports
import '../widgets/generate_button.dart';
import '../widgets/prompt_box.dart';

// 🎯 History, Models और OpenAI Service के Imports
import '../models/prompt_model.dart';
import '../services/history_service.dart';
import '../services/openai_service.dart'; // 🎯 OpenAI Service जोड़ा गया

class AIImageScreen extends StatefulWidget {
  const AIImageScreen({super.key});

  @override
  State<AIImageScreen> createState() => _AIImageScreenState();
}

class _AIImageScreenState extends State<AIImageScreen> {
  final TextEditingController promptController = TextEditingController();

  String selectedStyle = "Realistic";
  String selectedRatio = "16:9";
  String selectedQuality = "4K";

  final List<String> styles = [
    "Realistic",
    "Cinematic",
    "Anime",
    "Pixar",
    "3D",
    "Fantasy",
    "Ghibli",
    "Digital Art",
  ];

  final List<String> ratios = [
    "1:1",
    "16:9",
    "9:16",
    "4:5",
  ];

  final List<String> qualities = [
    "HD",
    "2K",
    "4K",
    "8K",
  ];

  String generatedPrompt = "";
  bool isGenerating = false;
  bool isFavorite = false;

  void generatePrompt() async {
    final messenger = ScaffoldMessenger.of(context);
    FocusScope.of(context).unfocus();

    if (promptController.text.trim().isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Please describe your image first!"),
        ),
      );
      return;
    }

    setState(() {
      isGenerating = true;
      generatedPrompt = "";
      isFavorite = false;
    });

    try {
      // 🎯 OpenAIService का उपयोग करके वास्तविक प्रॉम्प्ट जनरेट करना
      final basePrompt = promptController.text.trim();
      final fullPromptQuery = '''
Enhance the following description into a professional, highly detailed AI image generation prompt.

User Description: "$basePrompt"
Style: $selectedStyle
Quality: $selectedQuality
Aspect Ratio: $selectedRatio

Requirements:
- Make it rich with descriptive lighting, camera angles, color grading, and textures.
- Tailor it for AI generators like Midjourney, DALL-E 3, and Stable Diffusion.
- Keep it structured and powerful.
''';

      final result = await OpenAIService.generateText(fullPromptQuery);

      if (!mounted) return;

      if (result.startsWith("ERROR:") ||
          result.startsWith("❌") ||
          result.startsWith("⚠️")) {
        messenger.showSnackBar(
          SnackBar(content: Text(result)),
        );
      } else {
        setState(() {
          generatedPrompt = result;
        });

        // 🎯 Hive में सुरक्षित सेव करना (await और isFavorite: false के साथ)
        await HistoryService.addPrompt(
          PromptModel(
            title: basePrompt.length > 20
                ? "${basePrompt.substring(0, 20)}..."
                : basePrompt,
            prompt: result,
            createdAt: DateTime.now(),
            isFavorite: false,
          ),
        );

        if (!mounted) return;

        messenger.showSnackBar(
          const SnackBar(
            content: Text("Image prompt generated & saved successfully! 🎉"),
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
  }

  void clearAll() {
    setState(() {
      promptController.clear();
      generatedPrompt = "";
      selectedStyle = "Realistic";
      selectedRatio = "16:9";
      selectedQuality = "4K";
      isFavorite = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Form cleared successfully"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Image Prompt"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: clearAll,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Describe Your Image",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 🎯 मानक PromptBox का उपयोग
            PromptBox(
              controller: promptController,
              maxLength: 1000,
              hintText:
              "Describe your AI image...\n\nExample:\nA romantic couple walking in the rain, cinematic lighting, ultra realistic, 4K.",
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: selectedStyle,
              decoration: InputDecoration(
                labelText: "Image Style",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: styles
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStyle = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: selectedRatio,
              decoration: InputDecoration(
                labelText: "Aspect Ratio",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: ratios
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedRatio = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: selectedQuality,
              decoration: InputDecoration(
                labelText: "Image Quality",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: qualities
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedQuality = value!;
                });
              },
            ),

            const SizedBox(height: 25),

            // 🎯 मानक GenerateButton का उपयोग
            GenerateButton(
              text: "Generate Image Prompt",
              isLoading: isGenerating,
              onPressed: generatePrompt,
            ),

            const SizedBox(height: 10),

            // Clear Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: clearAll,
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear"),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
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
                        "Generated Image Prompt",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        generatedPrompt,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // 🎯 Favorite और Share Buttons का Row
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
                                isFavorite ? Icons.favorite : Icons.favorite_border,
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

                      // 🎯 Copy Button
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
                                    content: Text("Prompt copied successfully!"),
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