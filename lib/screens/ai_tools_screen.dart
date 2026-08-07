import 'package:flutter/material.dart';

import 'ai_chat_screen.dart';
import 'ai_thumbnail_screen.dart';

// 🎯 सभी ज़रूरी Screens के Imports
import 'ai_seo_screen.dart';
import 'ai_lyrics_screen.dart';
import 'ai_script_screen.dart';
import 'ai_music_screen.dart';
import 'ai_video_screen.dart';
import 'ai_image_screen.dart';

class AIToolsScreen extends StatefulWidget {
  const AIToolsScreen({super.key});

  @override
  State<AIToolsScreen> createState() => _AIToolsScreenState();
}

class _AIToolsScreenState extends State<AIToolsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _search = "";

  final List<Map<String, dynamic>> _tools = [
    {
      "title": "AI Chat",
      "subtitle": "Ask anything with AI",
      "icon": Icons.chat,
      "color": Colors.blue,
      "screen": const AIChatScreen(),
    },
    {
      "title": "AI Thumbnail",
      "subtitle": "Generate YouTube Thumbnail",
      "icon": Icons.image,
      "color": Colors.orange,
      "screen": const AIThumbnailScreen(),
    },
    {
      "title": "AI SEO",
      "subtitle": "SEO Title & Tags",
      "icon": Icons.search,
      "color": Colors.green,
      "screen": const AISEOScreen(),
    },
    {
      "title": "AI Lyrics",
      "subtitle": "Generate Lyrics",
      "icon": Icons.music_note,
      "color": Colors.purple,
      "screen": const AILyricsScreen(),
    },
    {
      "title": "AI Script",
      "subtitle": "Create Video Script",
      "icon": Icons.edit_note,
      "color": Colors.red,
      "screen": const AIScriptScreen(),
    },
    {
      "title": "AI Music Prompt",
      "subtitle": "Prompt Generator",
      "icon": Icons.library_music,
      "color": Colors.teal,
      "screen": const AIMusicScreen(),
    },
    {
      "title": "AI Video Prompt",
      "subtitle": "Create Video Prompt",
      "icon": Icons.movie_creation,
      "color": Colors.indigo,
      "screen": const AIVideoScreen(),
    },
    {
      "title": "AI Image",
      "subtitle": "Generate AI Images",
      "icon": Icons.auto_awesome,
      "color": Colors.deepPurple,
      "screen": const AIImageScreen(),
    },
  ];

  List<Map<String, dynamic>> get filteredTools {
    if (_search.isEmpty) {
      return _tools;
    }

    final query = _search.toLowerCase();

    return _tools.where((tool) {
      final title = tool["title"].toString().toLowerCase();
      final subtitle = tool["subtitle"].toString().toLowerCase();

      return title.contains(query) || subtitle.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Tools"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search AI tools...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _search = "";
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                // 🎯 सुधार 1: Overflow रोकने के लिए AspectRatio को 0.82 किया गया है
                childAspectRatio: 0.82,
              ),
              itemCount: filteredTools.length,
              itemBuilder: (context, index) {
                final tool = filteredTools[index];

                return Card(
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      final Widget? screen = tool["screen"] as Widget?;

                      if (screen != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => screen,
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Coming Soon"),
                              content: Text(
                                "${tool["title"]} will be available in the next update.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: (tool["color"] as Color).withValues(
                              alpha: 0.15,
                            ),
                            child: Icon(
                              tool["icon"] as IconData,
                              size: 34,
                              color: tool["color"] as Color,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            tool["title"].toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 🎯 सुधार 2: Text Overflow और Wrapping ठीक की गई है
                          Text(
                            tool["subtitle"].toString(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}