import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/languages.dart';
import '../providers/seo_provider.dart';
import '../widgets/app_dropdown.dart';
import '../widgets/app_text_field.dart';
import '../widgets/generate_button.dart';

class AIYouTubeSEOScreen extends StatefulWidget {
  const AIYouTubeSEOScreen({super.key});

  @override
  State<AIYouTubeSEOScreen> createState() => _AIYouTubeSEOScreenState();
}

class _AIYouTubeSEOScreenState extends State<AIYouTubeSEOScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();

  String language = "Hindi";
  String category = "Music";

  @override
  void dispose() {
    titleController.dispose();
    keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SEOProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("YouTube SEO Generator"),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  titleController.clear();
                  keywordController.clear();
                  provider.clear();

                  setState(() {
                    language = "Hindi";
                    category = "Music";
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
                  "Generate YouTube SEO",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // 🎯 Video Title Field
                AppTextField(
                  controller: titleController,
                  label: "Video Title",
                  hint: "Enter Video Title",
                  icon: Icons.title,
                ),

                const SizedBox(height: 20),

                // 🌍 Language AppDropdown
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

                // 📂 Category AppDropdown
                AppDropdown<String>(
                  label: "Category",
                  icon: Icons.category,
                  initialValue: category,
                  items: const [
                    "Music",
                    "Entertainment",
                    "Education",
                    "Gaming",
                    "Technology",
                    "Vlog",
                    "Comedy",
                    "Shorts",
                  ],
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // 🎯 Main Keywords Field
                AppTextField(
                  controller: keywordController,
                  label: "Main Keywords",
                  hint: "love song, romantic, hindi song...",
                  icon: Icons.edit_note,
                  maxLines: 3,
                ),

                const SizedBox(height: 25),

                // 🚀 Generate Button
                GenerateButton(
                  text: "Generate SEO",
                  isLoading: provider.isLoading,
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    FocusScope.of(context).unfocus();

                    if (titleController.text.trim().isEmpty) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text("Please enter video title"),
                        ),
                      );
                      return;
                    }

                    if (keywordController.text.trim().isEmpty) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text("Please enter keywords"),
                        ),
                      );
                      return;
                    }

                    final prompt = """
Create a complete professional YouTube SEO package.

Video Title:
${titleController.text}

Language:
$language

Category:
$category

Main Keywords:
${keywordController.text}

Generate:

1. 10 Viral SEO Titles

2. Professional YouTube Description

3. 30 SEO Tags

4. 20 Search Keywords

5. Community Post

6. Thumbnail Text

7. Hashtags

Make everything optimized for maximum YouTube reach.
""";

                    await provider.generate(prompt);

                    if (!mounted) return;

                    if (provider.hasResult) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text("YouTube SEO generated & saved successfully! 🎉"),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 25),

                // 📦 Result Card Section
                if (provider.hasResult)
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
                            "Generated YouTube SEO",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          SelectableText(
                            "Title:\n${provider.result.title}\n\n"
                                "Description:\n${provider.result.description}\n\n"
                                "Tags:\n${provider.result.tags}",
                          ),

                          const SizedBox(height: 20),

                          // Action Buttons (Share & Copy)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final fullText =
                                        "Title:\n${provider.result.title}\n\n"
                                        "Description:\n${provider.result.description}\n\n"
                                        "Tags:\n${provider.result.tags}";
                                    await SharePlus.instance.share(
                                      ShareParams(
                                        text: fullText,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.share),
                                  label: const Text("Share"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final messenger = ScaffoldMessenger.of(context);
                                    final fullText =
                                        "Title:\n${provider.result.title}\n\n"
                                        "Description:\n${provider.result.description}\n\n"
                                        "Tags:\n${provider.result.tags}";

                                    await Clipboard.setData(
                                      ClipboardData(text: fullText),
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
      },
    );
  }
}