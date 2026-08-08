import 'package:flutter/material.dart';

import 'ai_chat_screen.dart';
import 'ai_thumbnail_screen.dart';
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
  final TextEditingController _searchController =
  TextEditingController();

  String _search = '';

  late final List<_AIToolItem> _tools;

  @override
  void initState() {
    super.initState();

    _tools = [
      const _AIToolItem(
        title: 'AI Chat',
        subtitle: 'Ask anything with AI',
        icon: Icons.chat_rounded,
        color: Colors.blue,
        screen: AIChatScreen(),
      ),
      const _AIToolItem(
        title: 'AI Thumbnail',
        subtitle: 'Create YouTube thumbnails',
        icon: Icons.image_rounded,
        color: Colors.orange,
        screen: AIThumbnailScreen(),
      ),
      const _AIToolItem(
        title: 'AI SEO',
        subtitle: 'Titles, descriptions & tags',
        icon: Icons.search_rounded,
        color: Colors.green,
        screen: AISEOScreen(),
      ),
      const _AIToolItem(
        title: 'AI Lyrics',
        subtitle: 'Create original song lyrics',
        icon: Icons.music_note_rounded,
        color: Colors.purple,
        screen: AILyricsScreen(),
      ),
      const _AIToolItem(
        title: 'AI Script',
        subtitle: 'Create professional scripts',
        icon: Icons.edit_note_rounded,
        color: Colors.red,
        screen: AIScriptScreen(),
      ),
      const _AIToolItem(
        title: 'AI Music Prompt',
        subtitle: 'Prompts for AI music tools',
        icon: Icons.library_music_rounded,
        color: Colors.teal,
        screen: AIMusicScreen(),
      ),
      const _AIToolItem(
        title: 'AI Video Prompt',
        subtitle: 'Create cinematic prompts',
        icon: Icons.movie_creation_rounded,
        color: Colors.indigo,
        screen: AIVideoScreen(),
      ),
      const _AIToolItem(
        title: 'AI Image',
        subtitle: 'Generate AI images',
        icon: Icons.auto_awesome_rounded,
        color: Colors.deepPurple,
        screen: AIImageScreen(),
      ),
    ];
  }

  List<_AIToolItem> get _filteredTools {
    final query = _search.trim().toLowerCase();

    if (query.isEmpty) {
      return _tools;
    }

    return _tools.where((tool) {
      return tool.title.toLowerCase().contains(query) ||
          tool.subtitle.toLowerCase().contains(query);
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _search = '';
    });
  }

  void _openTool(_AIToolItem tool) {
    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => tool.screen,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tools = _filteredTools;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tools'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                8,
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search AI tools...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                  ),
                  suffixIcon: _search.trim().isNotEmpty
                      ? IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(
                      Icons.clear_rounded,
                    ),
                    onPressed: _clearSearch,
                  )
                      : null,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                4,
                18,
                8,
              ),
              child: Row(
                children: [
                  Text(
                    '${tools.length} ${tools.length == 1 ? 'Tool' : 'Tools'}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: tools.isEmpty
                  ? _buildEmptyState()
                  : LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  final crossAxisCount = width >= 900
                      ? 4
                      : width >= 600
                      ? 3
                      : 2;

                  final aspectRatio = width >= 600
                      ? 0.95
                      : 0.82;

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      24,
                    ),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: tools.length,
                    itemBuilder: (context, index) {
                      final tool = tools[index];

                      return _buildToolCard(tool);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(_AIToolItem tool) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openTool(tool),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: tool.color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  tool.icon,
                  size: 32,
                  color: tool.color,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                tool.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 7),

              Flexible(
                child: Text(
                  tool.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.3,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            const Text(
              'No AI tools found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: _clearSearch,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Show All Tools'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AIToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  const _AIToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}