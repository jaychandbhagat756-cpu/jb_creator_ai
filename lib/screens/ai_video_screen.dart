import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../data/languages.dart';
import '../models/prompt_model.dart';
import '../services/history_service.dart';
import '../services/openai_service.dart';
import '../widgets/generate_button.dart';

class AIVideoScreen extends StatefulWidget {
  const AIVideoScreen({super.key});

  @override
  State<AIVideoScreen> createState() => _AIVideoScreenState();
}

class _AIVideoScreenState extends State<AIVideoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController sceneController = TextEditingController();

  String language = "Hindi";
  String style = "Cinematic";
  String mood = "Romantic";
  String duration = "30 Seconds";

  String generatedPrompt = "";
  bool isGenerating = false;
  bool isFavorite = false;

  @override
  void dispose() {
    titleController.dispose();
    sceneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Video Prompt Generator"),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              titleController.clear();
              sceneController.clear();

              setState(() {
                generatedPrompt = "";
                isFavorite = false;
                isGenerating = false;
                language = "Hindi";
                style = "Cinematic";
                mood = "Romantic";
                duration = "30 Seconds";
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
              "Create Professional AI Video Prompt",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Video Title",
                hintText: "Enter video title...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🎯 Language Dropdown (initialValue)
            DropdownButtonFormField<String>(
              initialValue: language,
              decoration: InputDecoration(
                labelText: "Language",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: AppLanguages.list.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  language = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // 🎯 Video Style Dropdown (initialValue)
            DropdownButtonFormField<String>(
              initialValue: style,
              decoration: InputDecoration(
                labelText: "Video Style",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Cinematic",
                  child: Text("Cinematic"),
                ),
                DropdownMenuItem(
                  value: "Realistic",
                  child: Text("Realistic"),
                ),
                DropdownMenuItem(
                  value: "3D Animation",
                  child: Text("3D Animation"),
                ),
                DropdownMenuItem(
                  value: "Anime",
                  child: Text("Anime"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  style = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // 🎯 Mood Dropdown (initialValue)
            DropdownButtonFormField<String>(
              initialValue: mood,
              decoration: InputDecoration(
                labelText: "Mood",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Romantic",
                  child: Text("Romantic"),
                ),
                DropdownMenuItem(
                  value: "Sad",
                  child: Text("Sad"),
                ),
                DropdownMenuItem(
                  value: "Happy",
                  child: Text("Happy"),
                ),
                DropdownMenuItem(
                  value: "Action",
                  child: Text("Action"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  mood = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // 🎯 Duration Dropdown (initialValue)
            DropdownButtonFormField<String>(
              initialValue: duration,
              decoration: InputDecoration(
                labelText: "Duration",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "10 Seconds",
                  child: Text("10 Seconds"),
                ),
                DropdownMenuItem(
                  value: "30 Seconds",
                  child: Text("30 Seconds"),
                ),
                DropdownMenuItem(
                  value: "1 Minute",
                  child: Text("1 Minute"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  duration = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: sceneController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Scene Description",
                hintText:
                "Example: A romantic couple walking in the rain at sunset with cinematic camera movement...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),

            GenerateButton(
              text: "Generate Video Prompt",
              isLoading: isGenerating,
              onPressed: isGenerating
                  ? null
                  : () async {
                final messenger = ScaffoldMessenger.of(context);
                FocusScope.of(context).unfocus();

                if (titleController.text.trim().isEmpty ||
                    sceneController.text.trim().isEmpty) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Please fill all fields"),
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
Create a professional AI video prompt.

Title:
${titleController.text}

Language:
$language

Style:
$style

Mood:
$mood

Duration:
$duration

Scene:

${sceneController.text}

Generate a cinematic prompt suitable for:

• Runway Gen-4
• Veo 3
• Kling AI
• Pika
• Luma Dream Machine

Include:

• Camera
• Lens
• Lighting
• Environment
• Motion
• Color Grading
• Cinematic Details
• 4K Ultra HD
''';

                try {
                  final result = await OpenAIService.generateText(
                    prompt,
                  );

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
                    // 🎯 Hive में सेव करने का सुरक्षित तरीका (await और isFavorite: false के साथ)
                    await HistoryService.addPrompt(
                      PromptModel(
                        title: titleController.text,
                        prompt: result,
                        createdAt: DateTime.now(),
                        isFavorite: false,
                      ),
                    );

                    if (!mounted) return;

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text("Video prompt generated & saved successfully! 🎉"),
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
                        "Generated Video Prompt",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SelectableText(
                        generatedPrompt,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

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
                                    content: Text("Video prompt copied successfully!"),
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