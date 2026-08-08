import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../data/instrument_list.dart';
import '../data/languages.dart';
import '../data/moods.dart';
import '../data/music_styles.dart';
import '../widgets/app_dropdown.dart';
import '../widgets/app_text_field.dart';
import '../widgets/generate_button.dart';

// 🎯 जरूरी Imports (OpenAI Service के साथ)
import '../models/prompt_model.dart';
import '../services/history_service.dart';
import '../services/openai_service.dart';

class AILyricsScreen extends StatefulWidget {
  const AILyricsScreen({super.key});

  @override
  State<AILyricsScreen> createState() => _AILyricsScreenState();
}

class _AILyricsScreenState extends State<AILyricsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();

  String language = "Hindi";
  String mood = "Romantic";
  String style = "90s Bollywood";
  String singer = "Original";
  String duration = "5 Minutes";
  String instrument = "Piano";

  // --- अन्य Variables ---
  bool isGenerating = false;
  String generatedLyrics = "";
  bool isFavorite = false;
  bool familyFriendly = true;
  String rhymeStyle = "AABB";
  String songStructure = "Intro - Verse - Chorus - Verse - Bridge - Outro";

  @override
  void dispose() {
    titleController.dispose();
    keywordController.dispose();
    super.dispose();
  }

  String _friendlyError(String error) {
    switch (error) {
      case "ERROR: API_KEY":
        return "OpenAI API key is not configured.";

      case "ERROR: INVALID_API_KEY":
        return "Invalid OpenAI API key.";

      case "ERROR: BILLING_OR_RATE_LIMIT":
        return "OpenAI billing or rate-limit issue.";

      case "ERROR: ACCESS_DENIED":
        return "OpenAI access was denied.";

      case "ERROR: TIMEOUT":
        return "Request timed out. Please try again.";

      case "ERROR: NETWORK":
        return "Network error. Check your internet connection.";

      case "ERROR: EMPTY_PROMPT":
        return "Please enter the required information.";

      case "ERROR: SERVER":
        return "OpenAI server is temporarily unavailable.";

      default:
        return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("AI Lyrics Generator"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              titleController.clear();
              keywordController.clear();

              setState(() {
                generatedLyrics = "";
                isFavorite = false;
                language = "Hindi";
                mood = "Romantic";
                style = "90s Bollywood";
                singer = "Original";
                duration = "5 Minutes";
                instrument = "Piano";
                familyFriendly = true;
                rhymeStyle = "AABB";
                songStructure = "Intro - Verse - Chorus - Verse - Bridge - Outro";
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
              "Create Professional AI Lyrics",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            AppTextField(
              controller: titleController,
              label: "Song Title",
              hint: "Enter Song Title",
              icon: Icons.music_note,
            ),

            const SizedBox(height: 20),

            // 1️⃣ Language Dropdown
            AppDropdown<String>(
              label: "Language",
              icon: Icons.language,
              initialValue: language,
              items: AppLanguages.list,
              onChanged: (value) {
                setState(() {
                  language = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 2️⃣ Mood Dropdown
            AppDropdown<String>(
              label: "Mood",
              icon: Icons.favorite,
              initialValue: mood,
              items: AppMoods.list,
              onChanged: (value) {
                setState(() {
                  mood = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 3️⃣ Music Style Dropdown
            AppDropdown<String>(
              label: "Music Style",
              icon: Icons.library_music,
              initialValue: style,
              items: AppMusicStyles.list,
              onChanged: (value) {
                setState(() {
                  style = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 4️⃣ Singer Style Dropdown
            AppDropdown<String>(
              label: "Singer Style",
              icon: Icons.mic,
              initialValue: singer,
              items: const [
                "Original",
                "Classic Romantic",
                "Soft Melody",
                "Folk Style"
              ],
              onChanged: (value) {
                setState(() {
                  singer = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 5️⃣ Song Duration Dropdown
            AppDropdown<String>(
              label: "Song Duration",
              icon: Icons.timer,
              initialValue: duration,
              items: const [
                "2 Minutes",
                "3 Minutes",
                "5 Minutes",
                "8 Minutes"
              ],
              onChanged: (value) {
                setState(() {
                  duration = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // 6️⃣ Instrument Dropdown
            AppDropdown<String>(
              label: "Instrument",
              icon: Icons.piano,
              initialValue: instrument,
              items: InstrumentList.list,
              onChanged: (value) {
                setState(() {
                  instrument = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            AppTextField(
              controller: keywordController,
              label: "Keywords / Theme",
              hint: "Example: Rain, Love, Village, Heartbreak, Moonlight, Emotional, Wedding...",
              icon: Icons.edit_note,
              maxLines: 5,
            ),

            const SizedBox(height: 30),

            GenerateButton(
              text: "Generate Lyrics",
              isLoading: isGenerating,
              onPressed: isGenerating
                  ? null
                  : () async {
                // 🎯 1. शुरुआत में ही messenger को सुरक्षित कर लिया गया है
                final messenger = ScaffoldMessenger.of(context);

                // 🎯 बटन दबाते ही Keyboard Hide करना
                FocusScope.of(context).unfocus();

                // 🎯 Title Validation Check
                if (titleController.text.trim().isEmpty) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Please enter song title"),
                    ),
                  );
                  return;
                }

                // 🎯 Keywords Validation Check
                if (keywordController.text.trim().isEmpty) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Please enter keywords"),
                    ),
                  );
                  return;
                }

                final lyricsPrompt = '''
Create professional AI song lyrics.

Song Title: ${titleController.text}

Language: $language
Mood: $mood
Music Style: $style
Singer Style: $singer
Song Duration: $duration
Instrument: $instrument
Rhyme Style: $rhymeStyle
Song Structure: $songStructure
Family Friendly: ${familyFriendly ? "Yes" : "No"}

Theme / Keywords:
${keywordController.text}

Requirements:
- Write original lyrics in $language.
- Mood should be $mood.
- Music style should match $style.
- Singing style should match $singer.
- Song length should fit approximately $duration.
- Prominent instrument focus should be $instrument.
- Include Intro, Verse 1, Chorus, Verse 2, Bridge and Outro.
- Make the lyrics emotional, meaningful and suitable for AI music generators like Suno AI and Udio.
''';

                // 🎯 Reset State before Generating & Start Loading
                setState(() {
                  isGenerating = true;
                  generatedLyrics = "";
                  isFavorite = false;
                });

                try {
                  final aiLyrics = await OpenAIService.generateText(lyricsPrompt);

                  if (!mounted) return;

                  setState(() {
                    generatedLyrics = aiLyrics;
                  });

                  // 🎯 Handle the standardized OpenAIService errors.
                  final isError =
                      aiLyrics.startsWith("ERROR:") ||
                          aiLyrics.startsWith("❌") ||
                          aiLyrics.startsWith("⚠️");

                  if (isError) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(_friendlyError(aiLyrics)),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    // 🎯 Save to History first with await
                    await HistoryService.addPrompt(
                      PromptModel(
                        title: titleController.text,
                        prompt: aiLyrics,
                        createdAt: DateTime.now(),
                        isFavorite: false,
                      ),
                    );

                    if (!mounted) return;

                    // 🎯 Success Feedback using cached messenger
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text("Lyrics generated & saved successfully! 🎉"),
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

            const SizedBox(height: 25),

            if (generatedLyrics.isNotEmpty)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Generated Lyrics",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),

                      SelectableText(generatedLyrics),

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
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // 🎯 Updated Share functionality
                                await SharePlus.instance.share(
                                  ShareParams(
                                    text: generatedLyrics,
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
                                  ClipboardData(text: generatedLyrics),
                                );

                                if (!mounted) return;

                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text("Copied Successfully"),
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
