import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

import 'models/prompt_model.dart';
import 'models/project_model.dart';

import 'theme/app_theme.dart';

import 'screens/splash_screen.dart';

import 'providers/chat_provider.dart';
import 'providers/thumbnail_provider.dart';
import 'providers/seo_provider.dart';
import 'providers/lyrics_provider.dart';
import 'providers/music_prompt_provider.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive
  await Hive.initFlutter();

  // Register PromptModel Adapter
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(PromptModelAdapter());
  }

  // Register ProjectModel Adapter
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ProjectModelAdapter());
  }

  // Open Hive Boxes
  await Hive.openBox<PromptModel>('history');
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

        // Professional Theme Controller
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadTheme(),
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'JB Creator AI',

          // Light Theme
          theme: AppTheme.lightTheme,

          // Dark Theme
          darkTheme: AppTheme.darkTheme,

          // System / Light / Dark
          themeMode: themeProvider.flutterThemeMode,

          home: const SplashScreen(),
        );
      },
    );
  }
}
