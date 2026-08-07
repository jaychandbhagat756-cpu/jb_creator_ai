import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_dropdown.dart';
import '../services/openai_service.dart';
import '../services/history_service.dart';
import '../models/prompt_model.dart';

class ThumbnailPromptScreen extends StatefulWidget {
  const ThumbnailPromptScreen({super.key});

  @override
  State<ThumbnailPromptScreen> createState() =>
      _ThumbnailPromptScreenState();
}

class _ThumbnailPromptScreenState
    extends State<ThumbnailPromptScreen> {

  // 🎯 वेरिएबल्स और कंट्रोलर्स
  final TextEditingController titleController = TextEditingController();

  String platform = "YouTube";
  String style = "Cinematic";
  String mood = "Romantic";
  String scene = "Rain";
  String colorTheme = "Blue";

  // 🎯 OpenAI Integration के लिए वेरिएबल्स
  bool isGenerating = false;
  String generatedPrompt = "";

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Thumbnail Prompt Generator",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🎯 Professional Heading
            const Text(
              "Create Professional AI Thumbnail Prompt",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🎯 Thumbnail Title TextField
            AppTextField(
              controller: titleController,
              label: "Thumbnail Title",
              hint: "Enter Thumbnail Title",
              icon: Icons.title,
            ),

            const SizedBox(height: 20),

            // 🌍 Platform Dropdown (value -> initialValue)
            AppDropdown<String>(
              label: "Platform",
              icon: Icons.tv,
              initialValue: platform,
              items: const [
                "YouTube",
                "Instagram",
                "Facebook",
              ],
              onChanged: (value) {
                setState(() {
                  platform = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 🎨 Style Dropdown (value -> initialValue)
            AppDropdown<String>(
              label: "Style",
              icon: Icons.style,
              initialValue: style,
              items: const [
                "Cinematic",
                "Realistic",
                "3D",
                "Cartoon",
                "Anime",
              ],
              onChanged: (value) {
                setState(() {
                  style = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 😊 Mood Dropdown (value -> initialValue)
            AppDropdown<String>(
              label: "Mood",
              icon: Icons.mood,
              initialValue: mood,
              items: const [
                "Romantic",
                "Sad",
                "Happy",
                "Emotional",
                "Action",
              ],
              onChanged: (value) {
                setState(() {
                  mood = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 🌄 Background Dropdown (value -> initialValue)
            AppDropdown<String>(
              label: "Background Scene",
              icon: Icons.landscape,
              initialValue: scene,
              items: const [
                "Rain",
                "Forest",
                "Village",
                "Mountain",
                "City",
                "Studio",
              ],
              onChanged: (value) {
                setState(() {
                  scene = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 🎨 Color Theme Dropdown (value -> initialValue)
            AppDropdown<String>(
              label: "Color Theme",
              icon: Icons.color_lens,
              initialValue: colorTheme,
              items: const [
                "Blue",
                "Red",
                "Golden",
                "Dark",
                "Neon",
              ],
              onChanged: (value) {
                setState(() {
                  colorTheme = value!;
                });
              },
            ),

            const SizedBox(height: 25),

            // 🚀 Generate Button with Advanced OpenAI Integration
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.deepPurple.shade300,
                  disabledForegroundColor: Colors.white70,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: isGenerating
                    ? null
                    : () async {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter thumbnail title"),
                      ),
                    );
                    return;
                  }

                  // 🎯 एडवांस और विस्तृत AI प्रॉम्प्ट (कैमरा एंगल, लाइटिंग, कंपोजिशन और आस्पेक्ट रेश्यो के साथ)
                  final promptText = '''
Generate a professional, high-converting AI image generation prompt for a video thumbnail.
The prompt should be highly detailed, cinematic, photorealistic, and optimized for AI image generators (like Midjourney, DALL-E) with specific camera angles, dramatic lighting, composition, and a 16:9 aspect ratio.

Thumbnail Title:
${titleController.text}

Platform:
$platform

Style:
$style

Mood:
$mood

Background/Scene:
$scene

Color Theme:
$colorTheme

Create:
1. A detailed AI image generation prompt with camera angle, lighting details, composition, and aspect ratio (16:9) that clearly depicts this scene with stunning visuals.
2. 3 alternative text overlay ideas for the thumbnail.
''';

                  setState(() {
                    isGenerating = true;
                    generatedPrompt = "";
                  });

                  final result = await OpenAIService.generateText(promptText);

                  if (!mounted) return;

                  setState(() {
                    generatedPrompt = result;
                    isGenerating = false;
                  });

                  if (result.startsWith("❌") || result.startsWith("⚠️")) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    HistoryService.addPrompt(
                      PromptModel(
                        title: titleController.text,
                        prompt: result,
                        createdAt: DateTime.now(),
                      ),
                    );
                  }
                },
                icon: isGenerating
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.image_search),
                label: Text(
                  isGenerating ? "Generating Prompt..." : "Generate Thumbnail Prompt",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🎯 आकर्षक आइकॉन और शेयर बटन के साथ स्टाइलिश रिजल्ट कार्ड
            if (generatedPrompt.isNotEmpty &&
                !generatedPrompt.startsWith("❌") &&
                !generatedPrompt.startsWith("⚠️"))
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "🖼️ Generated AI Thumbnail Prompt",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // 🎯 Scrollable Result View
                      SizedBox(
                        height: 350,
                        child: SingleChildScrollView(
                          child: SelectableText(generatedPrompt),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          // 📋 Copy Button
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: generatedPrompt),
                                );

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Prompt copied successfully"),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.copy),
                              label: const Text("Copy"),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // 📤 Share Button
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
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

                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}