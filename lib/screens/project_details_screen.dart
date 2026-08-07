import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart'; // 🎯 Share plus इम्पोर्ट
import '../models/project_model.dart';
import 'edit_project_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      "dd MMM yyyy • hh:mm a",
    ).format(widget.project.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.deepPurple.shade100,
                child: const Icon(
                  Icons.folder,
                  size: 45,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              widget.project.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.project.description.isEmpty
                      ? "No Description"
                      : widget.project.description,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Created",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text(date),
              ),
            ),

            const SizedBox(height: 35),

            // 🎯 Edit Project Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit Project"),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProjectScreen(
                        project: widget.project,
                      ),
                    ),
                  );

                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ),

            const SizedBox(height: 15),

            // 🎯 Updated Share Button using SharePlus & ShareParams
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text("Share"),
                onPressed: () async {
                  await SharePlus.instance.share(
                    ShareParams(
                      text:
                      'Project: ${widget.project.name}\n\nDescription:\n${widget.project.description}',
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // 🎯 Delete Button Logic
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: const Text(
                  "Delete Project",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Project"),
                      content: Text(
                        "Are you sure you want to delete '${widget.project.name}'?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final box = Hive.box<ProjectModel>('projects');
                    await box.delete(widget.project.key);

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Project Deleted"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}