import 'package:flutter/material.dart';

import 'ai_lyrics_screen.dart';
import 'ai_script_screen.dart';
import 'ai_thumbnail_screen.dart';
import 'ai_video_screen.dart';
import 'ai_youtube_seo_screen.dart';
import 'ai_music_screen.dart';

class ProjectDashboardScreen extends StatelessWidget {
  final String projectName;

  const ProjectDashboardScreen({
    super.key,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [

            _toolCard(
              context,
              "AI Lyrics",
              Icons.music_note,
              const AILyricsScreen(),
            ),

            _toolCard(
              context,
              "AI Script",
              Icons.edit_document,
              const AIScriptScreen(),
            ),

            _toolCard(
              context,
              "Thumbnail",
              Icons.image,
              const AIThumbnailScreen(),
            ),

            _toolCard(
              context,
              "Video",
              Icons.video_collection,
              const AIVideoScreen(),
            ),

            _toolCard(
              context,
              "SEO",
              Icons.trending_up,
              const AIYouTubeSEOScreen(),
            ),

            _toolCard(
              context,
              "Music Prompt",
              Icons.queue_music,
              const AIMusicScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolCard(
      BuildContext context,
      String title,
      IconData icon,
      Widget page,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 45,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}