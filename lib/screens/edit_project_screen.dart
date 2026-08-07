import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/project_model.dart';

class EditProjectScreen extends StatefulWidget {
  final ProjectModel project;

  const EditProjectScreen({
    super.key,
    required this.project,
  });

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.project.name,
    );

    descriptionController = TextEditingController(
      text: widget.project.description,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> saveProject() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Project name is required"),
        ),
      );
      return;
    }

    final box = Hive.box<ProjectModel>('projects');

    final updatedProject = ProjectModel(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      createdAt: widget.project.createdAt,
    );

    await box.put(widget.project.key, updatedProject);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Project"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Project Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveProject,
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}