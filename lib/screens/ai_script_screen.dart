import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../models/prompt_model.dart';
import '../services/history_service.dart';
import '../services/openai_service.dart';
import '../widgets/generate_button.dart'; // 🎯 मानक GenerateButton का Import

class AIScriptScreen extends StatefulWidget {
  const AIScriptScreen({super.key});

  @override
  State<AIScriptScreen> createState() => _AIScriptScreenState();
}

class _AIScriptScreenState extends State<AIScriptScreen> {
  final TextEditingController topicController = TextEditingController();

  String scriptType = "YouTube Video";
  String language = "Hindi";
  String tone = "Professional";
  String duration = "5 Minutes";

  final List<String> scriptTypes = [
    "YouTube Video",
    "YouTube Shorts",
    "Podcast",
    "Story",
    "Advertisement",
    "Instagram Reel",
  ];

  final List<String> languages = [
    "Hindi",
    "English",
    "Hinglish",
    "Nagpuri",
    "Chhattisgarhi",
  ];

  final List<String> tones = [
    "Professional",
    "Motivational",
    "Emotional",
    "Funny",
    "Educational",
  ];

  final List<String> durations = [
    "30 Seconds",
    "1 Minute",
    "3 Minutes",
    "5 Minutes",
    "10 Minutes",
  ];

  String generatedScript = "";
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
        title: const Text("AI Script Generator"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              topicController.clear();
              setState(() {
                generatedScript = "";
                isGenerating = false;
                isFavorite = false;
                scriptType = "YouTube Video";
                language = "Hindi";
                tone = "Professional";
                duration = "5 Minutes";
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
              "Script Topic",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // TextField with MaxLength
            TextField(
              controller: topicController,
              maxLines: 4,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: "Enter your topic, e.g., How to start a YouTube channel in 2026...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown: Script Type (Using initialValue)
            DropdownButtonFormField<String>(
              initialValue: scriptType,
              decoration: InputDecoration(
                labelText: "Script Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: scriptTypes.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  scriptType = value!;
                });
              },
            ),
            const SizedBox(height: 15),

            // Dropdown: Language (Using initialValue)
            DropdownButtonFormField<String>(
              initialValue: language,
              decoration: InputDecoration(
                labelText: "Language",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: languages.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  language = value!;
                });
              },
            ),
            const SizedBox(height: 15),

            // Dropdown: Tone (Using initialValue)
            DropdownButtonFormField<String>(
              initialValue: tone,
              decoration: InputDecoration(
                labelText: "Tone",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: tones.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tone = value!;
                });
              },
            ),
            const SizedBox(height: 15),

            // Dropdown: Duration (Using initialValue)
            DropdownButtonFormField<String>(
              initialValue: duration,
              decoration: InputDecoration(
                labelText: "Script Duration",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: durations.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  duration = value!;
                });
              },
            ),
            const SizedBox(height: 25),

            // Generate Button
            GenerateButton(
              text: "Generate Script",
              isLoading: isGenerating,
              onPressed: isGenerating
                  ? null
                  : () async {
                final messenger = ScaffoldMessenger.of(context);
                FocusScope.of(context).unfocus();

                // Topic Validation (< 5 Characters Check)
                if (topicController.text.trim().length < 5) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Please enter at least 5 characters for the topic"),
                    ),
                  );
                  return;
                }

                setState(() {
                  isGenerating = true;
                  generatedScript = "";
                  isFavorite = false;
                });

                // Professional AI Prompt Format
                final prompt = '''
You are an expert YouTube Script Writer.
Generate an original script.

Topic: ${topicController.text}
Script Type: $scriptType
Language: $language
Tone: $tone
Duration: $duration
CTA: Included
SEO Friendly: Yes

Write a complete, engaging script with:
- Hook
- Introduction
- Main Content
- Ending
- Call To Action
''';

                try {
                  final result = await OpenAIService.generateText(
                    prompt,
                  );

                  if (!mounted) return;

                  setState(() {
                    generatedScript = result;
                  });

                  if (result.startsWith("ERROR:") ||
                      result.startsWith("❌") ||
                      result.startsWith("⚠️")) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(result)),
                    );
                  } else {
                    await HistoryService.addPrompt(
                      PromptModel(
                        title: topicController.text,
                        prompt: result,
                        createdAt: DateTime.now(),
                        isFavorite: isFavorite,
                      ),
                    );

                    if (!mounted) return;

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Script generated & saved successfully! 🎉",
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

            if (generatedScript.isNotEmpty)
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
                        "Generated Script",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SelectableText(
                        generatedScript,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Favorite & Share Buttons
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
                                    text: generatedScript,
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
                                  ClipboardData(text: generatedScript),
                                );
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text("Script copied to clipboard"),
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