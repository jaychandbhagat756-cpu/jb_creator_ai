import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'profile_screen.dart'; // 🎯 ProfileScreen Import जोड़ा गया

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              children: [ // 🎯 const हटाया गया क्योंकि ListTile में onTap जोड़ा गया है

                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Profile"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () { // 🎯 ProfileScreen पर जाने के लिए onTap जोड़ा गया
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1),

                const ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text("Dark Mode"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),

                const Divider(height: 1),

                const ListTile(
                  leading: Icon(Icons.language),
                  title: Text("Language"),
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
                await AuthService.logout();

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
}