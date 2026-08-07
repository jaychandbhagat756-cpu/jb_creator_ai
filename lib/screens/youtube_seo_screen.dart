import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/openai_service.dart';
import '../services/history_service.dart';
import '../models/prompt_model.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_dropdown.dart';

class YouTubeSEOScreen extends StatefulWidget {
  const YouTubeSEOScreen({super.key});

  @override
  State<YouTubeSEOScreen> createState() => _YouTubeSEOScreenState();
}

class _YouTubeSEOScreenState extends State<YouTubeSEOScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();

  // 🎯 वेरिएबल्स
  String language = "Hindi";
  String mood = "Romantic";
  String musicStyle = "90s Bollywood";
  String singerStyle = "Original";

  bool isGenerating = false;
  String generatedSEO = "";

  @override
  void dispose() {
    titleController.dispose();
    keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "YouTube SEO Generator",
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

            const Text(
              "Generate Professional YouTube SEO",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🎯 Song Title TextField (AppTextField)
            AppTextField(
              controller: titleController,
              label: "Song Title",
              hint: "Enter Song Title",
              icon: Icons.music_note,
            ),

            const SizedBox(height: 20),

            // 🌍 Language Dropdown (value -> initialValue)
            AppDropdown<String>(
              label: "Language",
              icon: Icons.language,
              initialValue: language,
              items: const [
                "Hindi",
                "English",
                "Nagpuri",
                "Sadri",
                "Chhattisgarhi",
              ],
              onChanged: (value) {
                setState(() {
                  language = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // ❤️ Mood Dropdown (value -> initialValue)
            AppDropdown<String>(
              label: "Mood",
              icon: Icons.mood,
              initialValue: mood,
              items: const [
                "Romantic",
                "Sad",
                "Happy",
                "Emotional",
                "Dance",
              ],
              onChanged: (value) {
                setState(() {
                  mood = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 🎼 Music Style Dropdown (value -> initialValue)
            AppDropdown<String>(
              label: "Music Style",
              icon: Icons.library_music,
              initialValue: musicStyle,
              items: const [
                "90s Bollywood",
                "80s Bollywood",
                "Modern Pop",
                "Folk",
              ],
              onChanged: (value) {
                setState(() {
                  musicStyle = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 🎤 Singer Style Dropdown (value -> initialValue)
            AppDropdown<String>(
              label: "Singer Style",
              icon: Icons.mic,
              initialValue: singerStyle,
              items: const [
                "Original",
                "Classic Romantic",
                "Soft Melody",
              ],
              onChanged: (value) {
                setState(() {
                  singerStyle = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 🎯 Keywords TextField (AppTextField)
            AppTextField(
              controller: keywordController,
              label: "Keywords",
              hint: "Love, Rain, Romantic...",
              icon: Icons.edit_note,
              maxLines: 5,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                // 🎯 1. बेहतर डिसेबलड बटन स्टाइल जोड़ी गई
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
                        content: Text("Please enter song title"),
                      ),
                    );
                    return;
                  }

                  if (keywordController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter keywords"),
                      ),
                    );
                    return;
                  }

                  final seoPrompt = '''
Generate professional YouTube SEO for an AI-generated music video.

Song Title:
${titleController.text}

Language:
$language

Mood:
$mood

Music Style:
$musicStyle

Singer Style:
$singerStyle

Keywords:
${keywordController.text}

Create:

1. A highly clickable YouTube title.

2. A professional SEO description (300+ words).

3. 30 comma-separated SEO tags.

4. 20 relevant hashtags.

5. A pinned comment encouraging engagement.

6. A professional community post.

Write everything in the selected language.
''';

                  setState(() {
                    isGenerating = true;
                    generatedSEO = "";
                  });

                  final result = await OpenAIService.generateText(seoPrompt);

                  // 🎯 2. सुरक्षित स्टेट अपडेट के लिए mounted चेक
                  if (!mounted) return;

                  setState(() {
                    generatedSEO = result;
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
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  isGenerating ? "Generating SEO..." : "Generate SEO",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (generatedSEO.isNotEmpty &&
                !generatedSEO.startsWith("❌") &&
                !generatedSEO.startsWith("⚠️"))
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
                        "Generated YouTube SEO",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        height: 350,
                        child: SingleChildScrollView(
                          child: SelectableText(generatedSEO),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
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
                                  ClipboardData(text: generatedSEO),
                                );

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("SEO copied successfully"),
                                    ),
                                  );
                                }
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