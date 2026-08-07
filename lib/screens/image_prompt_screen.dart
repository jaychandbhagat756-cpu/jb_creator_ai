import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard के लिए
import '../widgets/app_text_field.dart';
import '../widgets/app_dropdown.dart';
import '../services/openai_service.dart';
import '../services/history_service.dart';
import '../models/prompt_model.dart';

class ImagePromptScreen extends StatefulWidget {
  const ImagePromptScreen({super.key});

  @override
  State<ImagePromptScreen> createState() => _ImagePromptScreenState();
}

class _ImagePromptScreenState extends State<ImagePromptScreen> {
  // Step 2: Variables
  final TextEditingController titleController = TextEditingController();

  String language = "English";
  String imageStyle = "Photorealistic";
  String background = "Nature";
  String lighting = "Golden Hour";
  String aspectRatio = "16:9";
  String colorTheme = "Vibrant";

  bool isGenerating = false;
  String generatedPrompt = "";

  // 1️⃣ Memory leak रोकने के लिए dispose()
  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  // 🚀 असली OpenAI Service और History Integration के साथ Prompt Generate करने का लॉजिक
  void generatePrompt() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an image title or concept!")),
      );
      return;
    }

    setState(() {
      isGenerating = true;
      generatedPrompt = "";
    });

    try {
      // प्रॉम्प्ट स्ट्रक्चर तैयार करें जो AI को भेजा जाएगा
      final String aiQuery =
          "Create a professional AI image prompt based on the following details: "
          "Title/Concept: ${titleController.text.trim()}, "
          "Language: $language, "
          "Style: $imageStyle, "
          "Background: $background, "
          "Lighting: $lighting, "
          "Aspect Ratio: $aspectRatio, "
          "Color Theme: $colorTheme. "
          "Provide a rich, descriptive, high-quality prompt ready for Midjourney or DALL-E.";

      // 1️⃣ असली OpenAI API Call
      final String result = await OpenAIService.generateText(aiQuery);

      // 🛡️ Async Gap Check
      if (!mounted) return;

      setState(() {
        generatedPrompt = result;
        isGenerating = false;
      });

      // 2️⃣ History Service में सही तरीके से PromptModel पास करना (बिना await के)
      HistoryService.addPrompt(
        PromptModel(
          title: titleController.text.trim(),
          prompt: result,
          createdAt: DateTime.now(),
        ),
      );

    } catch (e) {
      // 🛡️ Async Gap Check in Catch
      if (!mounted) return;

      setState(() {
        isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Step 3: AppBar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          "Image Prompt Generator",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step 4: Heading
            const Text(
              "Create Professional AI Image Prompt",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Step 5: Fields (Image Title, Language, Style, Background, Lighting, Aspect Ratio, Color Theme)
            AppTextField(
              controller: titleController,
              label: "Image Title / Concept",
              hint: "e.g., Cyberpunk futuristic city",
              icon: Icons.title,
            ),
            const SizedBox(height: 15),

            // 1️⃣ Language
            AppDropdown<String>(
              label: "Language",
              initialValue: language,
              items: const ["English", "Hindi", "Spanish", "French"],
              onChanged: (val) {
                setState(() {
                  language = val!;
                });
              },
            ),
            const SizedBox(height: 15),

            // 2️⃣ Image Style
            AppDropdown<String>(
              label: "Image Style",
              initialValue: imageStyle,
              items: const ["Photorealistic", "Anime", "3D Render", "Oil Painting", "Cyberpunk"],
              onChanged: (val) {
                setState(() {
                  imageStyle = val!;
                });
              },
            ),
            const SizedBox(height: 15),

            // 3️⃣ Background
            AppDropdown<String>(
              label: "Background",
              initialValue: background,
              items: const ["Nature", "Studio", "Cityscape", "Space", "Abstract"],
              onChanged: (val) {
                setState(() {
                  background = val!;
                });
              },
            ),
            const SizedBox(height: 15),

            // 4️⃣ Lighting
            AppDropdown<String>(
              label: "Lighting",
              initialValue: lighting,
              items: const ["Golden Hour", "Neon Lights", "Studio Soft Light", "Dramatic Shadows", "Cinematic"],
              onChanged: (val) {
                setState(() {
                  lighting = val!;
                });
              },
            ),
            const SizedBox(height: 15),

            // 5️⃣ Aspect Ratio
            AppDropdown<String>(
              label: "Aspect Ratio",
              initialValue: aspectRatio,
              items: const ["16:9", "9:16", "1:1", "4:3"],
              onChanged: (val) {
                setState(() {
                  aspectRatio = val!;
                });
              },
            ),
            const SizedBox(height: 15),

            // 6️⃣ Color Theme
            AppDropdown<String>(
              label: "Color Theme",
              initialValue: colorTheme,
              items: const ["Vibrant", "Pastel", "Dark & Moody", "Monochrome", "Neon"],
              onChanged: (val) {
                setState(() {
                  colorTheme = val!;
                });
              },
            ),
            const SizedBox(height: 30),

            // Step 6: Generate Button with Loading State
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: isGenerating ? null : generatePrompt,
                icon: isGenerating
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.image_search),
                label: Text(
                  isGenerating ? "Generating Prompt..." : "Generate Image Prompt",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Step 7: Result Card
            if (generatedPrompt.isNotEmpty) ...[
              const Text(
                "Generated Prompt:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.deepPurple.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      generatedPrompt,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: generatedPrompt));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Prompt copied to clipboard!")),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text("Copy Prompt"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}