import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/project_model.dart';
import 'project_details_screen.dart'; // 🎯 ProjectDetailsScreen इम्पोर्ट जोड़ा गया

class AllProjectsScreen extends StatefulWidget {
  const AllProjectsScreen({super.key});

  @override
  State<AllProjectsScreen> createState() => _AllProjectsScreenState();
}

class _AllProjectsScreenState extends State<AllProjectsScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Projects"),
      ),
      body: ValueListenableBuilder<Box<ProjectModel>>(
        valueListenable: Hive.box<ProjectModel>('projects').listenable(),
        builder: (context, box, _) {
          // 🎯 Search Box हमेशा ऊपर दिखाने के लिए Column को बाहर रखा गया है
          final allProjects = box.values.toList().reversed.toList();

          final projects = allProjects
              .where(
                (project) =>
                project.name.toLowerCase().contains(searchText),
          )
              .toList();

          return Column(
            children: [
              // 🎯 Search Box Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search Project...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value.toLowerCase();
                    });
                  },
                ),
              ),

              // 🎯 Projects List View or Empty State
              Expanded(
                child: box.isEmpty
                    ? const Center(
                  child: Text(
                    "No Projects Found",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : projects.isEmpty
                    ? const Center(
                  child: Text(
                    "No matching projects found",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.folder, color: Colors.white),
                        ),
                        title: Text(
                          project.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          project.description.isNotEmpty
                              ? project.description
                              : "No description",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // 🎯 PopupMenuButton (Open, Edit, Delete, Share)
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            switch (value) {
                              case 'open':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProjectDetailsScreen(
                                      project: project,
                                    ),
                                  ),
                                );
                                break;

                              case 'edit':
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Edit Project (Coming Soon)"),
                                  ),
                                );
                                break;

                              case 'delete':
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Project"),
                                    content: Text(
                                      "Are you sure you want to delete '${project.name}'?",
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
                                  // 🎯 स्टेबल तरीके से Hive बॉक्स की की (key) के माध्यम से डिलीट करना
                                  final key = project.key;
                                  await box.delete(key);

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Project Deleted"),
                                    ),
                                  );
                                }

                                break;

                              case 'share':
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Share Feature Coming Soon"),
                                  ),
                                );
                                break;
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'open',
                              child: Row(
                                children: [
                                  Icon(Icons.folder_open),
                                  SizedBox(width: 10),
                                  Text("Open"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 10),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'share',
                              child: Row(
                                children: [
                                  Icon(Icons.share),
                                  SizedBox(width: 10),
                                  Text("Share"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProjectDetailsScreen(
                                project: project,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}