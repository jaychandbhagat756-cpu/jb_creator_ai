import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🎯 Firebase Auth Import

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 55,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              user?.displayName?.isNotEmpty == true
                  ? user!.displayName!
                  : "JB Creator AI User",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              user?.email ?? "No Email",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: Text(user?.email ?? "-"),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.verified_user),
                title: const Text("Email Verified"),
                subtitle: Text(
                  user?.emailVerified == true
                      ? "Verified"
                      : "Not Verified",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}