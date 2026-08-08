import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Account",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Profile"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1),

                // 🌙 Professional Theme Setting
                ListTile(
                  leading: Icon(
                    themeProvider.themeMode == AppThemeMode.dark
                        ? Icons.dark_mode
                        : themeProvider.themeMode == AppThemeMode.light
                        ? Icons.light_mode
                        : Icons.brightness_auto,
                  ),
                  title: const Text("Theme"),
                  subtitle: Text(
                    _themeName(themeProvider.themeMode),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showThemeSelector(
                      context,
                      themeProvider,
                    );
                  },
                ),

                const Divider(height: 1),

                const ListTile(
                  leading: Icon(Icons.language),
                  title: Text("Language"),
                  subtitle: Text("English"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Application",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text("Notifications"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.cloud_sync),
                  title: Text("Backup & Sync"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.workspace_premium),
                  title: Text("Premium"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Support",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.star_rate),
                  title: Text("Rate App"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text("Share App"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text("Privacy Policy"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("About"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () async {
                await AuthService().signOut();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  static String _themeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return "Light";
      case AppThemeMode.dark:
        return "Dark";
      case AppThemeMode.system:
        return "System Default";
    }
  }

  static void _showThemeSelector(
      BuildContext context,
      ThemeProvider themeProvider,
      ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose Theme",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _themeOption(
                  context,
                  themeProvider,
                  AppThemeMode.system,
                  Icons.brightness_auto,
                  "System Default",
                  "Follow your device theme",
                ),

                _themeOption(
                  context,
                  themeProvider,
                  AppThemeMode.light,
                  Icons.light_mode,
                  "Light",
                  "Use light appearance",
                ),

                _themeOption(
                  context,
                  themeProvider,
                  AppThemeMode.dark,
                  Icons.dark_mode,
                  "Dark",
                  "Use dark appearance",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _themeOption(
      BuildContext context,
      ThemeProvider themeProvider,
      AppThemeMode mode,
      IconData icon,
      String title,
      String subtitle,
      ) {
    final selected = themeProvider.themeMode == mode;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: selected
          ? const Icon(
        Icons.check_circle,
        color: Colors.green,
      )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      onTap: () async {
        await themeProvider.setThemeMode(mode);

        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }
}