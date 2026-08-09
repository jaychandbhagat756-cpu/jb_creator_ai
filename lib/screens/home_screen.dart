import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // 🎯 तारीख फॉर्मेट करने के लिए इम्पोर्ट
import '../tool_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/premium_logo.dart';
import '../models/project_model.dart'; // 🎯 ProjectModel इम्पोर्ट टाइप सेफ्टी के लिए

import 'ai_chat_screen.dart';
import 'ai_music_screen.dart';
import 'ai_lyrics_screen.dart';
import 'youtube_seo_screen.dart';
import 'thumbnail_prompt_screen.dart';
import 'create_project_screen.dart';
import 'all_projects_screen.dart'; // 🎯 "View All" के लिए इम्पोर्ट

import 'image_prompt_screen.dart';
import 'ai_video_screen.dart';
import 'ai_script_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // 🎯 1. Updated Recent Project Card Method with InkWell & Compact Date
  Widget _recentProjectCard(ProjectModel project) {
    // कॉम्पैक्ट तारीख फॉर्मेट (जैसे: 06 Aug)
    final formattedDate = DateFormat('dd MMM').format(project.createdAt);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        // 🎯 आगे Project Details Screen पर जाने के लिए यहाँ नेविगेशन जोड़ सकते हैं
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withValues(alpha: 0.12),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.deepPurple.withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.folder,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                ),
                Text(
                  formattedDate, // 🎯 कॉम्पैक्ट तारीख (06 Aug)
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              project.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              project.description.isNotEmpty
                  ? project.description
                  : "No description",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 Greeting Method
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : (user?.email?.split('@').first ?? "Creator");

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      // 🎯 Premium AppBar with working Notification Button
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "JB Creator AI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Notifications",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.deepPurple,
              child: Text(
                user?.email?.substring(0, 1).toUpperCase() ?? "J",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      // 🎯 Floating Action Button (Quick New Project)
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("New Project"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateProjectScreen(),
            ),
          );
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🎯 Dynamic Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6C63FF),
                    Color(0xFF00C2FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.18),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const PremiumLogo(
                    size: 70,
                    showSubtitle: false,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "👋 ${getGreeting()}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Create Amazing AI Content",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          color: Colors.amber,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "PRO",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            AppTextField(
              controller: searchController,
              label: "Search AI Tools",
              hint: "Search AI Tools...",
              icon: Icons.search,
            ),

            const SizedBox(height: 30),

            // 🎯 Recent Projects Section Header with Clickable "View All"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "📁 Recent Projects",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllProjectsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 🎯 Live Recent Projects Horizontal Scroll from Hive
            SizedBox(
              height: 130,
              child: ValueListenableBuilder<Box<ProjectModel>>(
                valueListenable: Hive.box<ProjectModel>('projects').listenable(),
                builder: (context, box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Projects Yet",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  final projects = box.values.toList().reversed.toList();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: projects.length > 5 ? 5 : projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return _recentProjectCard(project);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // 🎯 AI Tools Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.82,
              children: [
                ToolCard(
                  icon: Icons.smart_toy,
                  title: "AI Chat",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AIChatScreen(),
                      ),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.music_note,
                  title: "Lyrics",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AILyricsScreen(),
                      ),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.library_music,
                  title: "Music Prompt",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AIMusicScreen(),
                      ),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.image,
                  title: "Image Prompt",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImagePromptScreen(),
                      ),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.movie_creation,
                  title: "Video Prompt",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AIVideoScreen(),
                      ),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.trending_up,
                  title: "YouTube SEO",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YouTubeSEOScreen(),
                      ),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.photo,
                  title: "Thumbnail",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThumbnailPromptScreen(),
                      ),
                    );
                  },
                ),
                ToolCard(
                  icon: Icons.edit_document,
                  title: "Script Writer",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AIScriptScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 🎯 Dashboard Statistics Header
            const Text(
              "📊 Dashboard Statistics",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // 🎯 Live Statistics with Generic Type-Safe Hive Builder ('projects')
            ValueListenableBuilder(
              valueListenable: Hive.box<ProjectModel>('projects').listenable(),
              builder: (context, Box<ProjectModel> box, _) {
                final int projectCount = box.length;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Creator Stats",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "$projectCount", // 🎯 Live Hive Count with Type Safety
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const Text("Projects"),
                            ],
                          ),
                          const Column(
                            children: [
                              Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text("Prompts"),
                            ],
                          ),
                          const Column(
                            children: [
                              Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Text("Favorites"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            const Text(
              "⚡ Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateProjectScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text(
                  "Create New AI Project",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // 🎯 Footer / Version Info
            const Center(
              child: Column(
                children: [
                  Text(
                    "JB Creator AI",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
