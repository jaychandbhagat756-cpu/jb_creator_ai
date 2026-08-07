import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'models/prompt_model.dart';
import 'models/project_model.dart'; // 🎯 ProjectModel Import जोड़ा गया

import 'theme/app_theme.dart';
import 'screens/login_screen.dart'; // 🎯 LoginScreen Import जोड़ा गया

import 'providers/chat_provider.dart';
import 'providers/thumbnail_provider.dart';
import 'providers/seo_provider.dart';
import 'providers/lyrics_provider.dart';
import 'providers/music_prompt_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive Initialize
  await Hive.initFlutter();

  // Register Adapter Safely
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(PromptModelAdapter());
  }

  // 🎯 ProjectModel Adapter Register किया गया
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ProjectModelAdapter());
  }

  // Open History Box
  await Hive.openBox<PromptModel>('history');

  // 🎯 Open Projects Box
  await Hive.openBox<ProjectModel>('projects');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThumbnailProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SEOProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LyricsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MusicPromptProvider(),
        ),
      ],
      child: const JBCreatorAI(),
    ),
  );
}

class JBCreatorAI extends StatelessWidget {
  const JBCreatorAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JB Creator AI',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(), // 🎯 Ab app start hone par LoginScreen dikhega
    );
  }
}