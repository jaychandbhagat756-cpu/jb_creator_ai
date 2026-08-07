import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/project_model.dart';
import 'project_dashboard_screen.dart'; // 🎯 प्रोजेक्ट डैशबोर्ड स्क्रीन का इम्पोर्ट

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() =>
      _CreateProjectScreenState();
}

class _CreateProjectScreenState
    extends State<CreateProjectScreen> {

  final TextEditingController projectNameController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  @override
  void dispose() {
    projectNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create AI Project"),
        centerTitle: true,
      ),

      body: ValueListenableBuilder(
        valueListenable: Hive.box<ProjectModel>('projects').listenable(),
        builder: (context, Box<ProjectModel> box, _) {
          return Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                TextField(
                  controller: projectNameController,
                  decoration: const InputDecoration(
                    labelText: "Project Name",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Project Description",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: () {
                      if (projectNameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter project name"),
                          ),
                        );
                        return;
                      }

                      // 🎯 Hive बॉक्स में प्रोजेक्ट सेव करना
                      final projectBox = Hive.box<ProjectModel>('projects');

                      projectBox.add(
                        ProjectModel(
                          name: projectNameController.text.trim(),
                          description: descriptionController.text.trim(),
                          createdAt: DateTime.now(),
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Project '${projectNameController.text}' created & saved successfully! 🎉",
                          ),
                        ),
                      );

                      projectNameController.clear();
                      descriptionController.clear();
                    },
                    child: const Text(
                      "Create Project",
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🎯 My Projects Heading
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "📁 My Projects",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 🎯 Saved Projects List View
                Expanded(
                  child: box.isEmpty
                      ? const Center(
                    child: Text(
                      "No Projects Yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final project = box.getAt(index)!;

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.folder, color: Colors.deepPurple),
                          title: Text(
                            project.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            project.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 📂 Open Button with Navigation to Dashboard
                              IconButton(
                                icon: const Icon(
                                  Icons.folder_open,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProjectDashboardScreen(
                                        projectName: project.name,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // 🗑 Delete Button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  box.deleteAt(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}