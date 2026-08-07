import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../models/prompt_model.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // 🎯 Search Controller और Variables
  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  // 🎯 Performance Optimization: History लिस्ट को State में रखना
  List<PromptModel> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // 📦 डेटा लोड करने का सुरक्षित मेथड (Mounted Check के साथ)
  void _loadHistory() {
    if (!mounted) return;

    setState(() {
      history = HistoryService.getHistory();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 Search Filter Logic: टाइटल या प्रॉम्प्ट के आधार पर फ़िल्टर करना
    final filteredHistory = history.where((item) {
      return item.title.toLowerCase().contains(searchText) ||
          item.prompt.toLowerCase().contains(searchText);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prompt History"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: "Clear All History",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text("Clear History"),
                    content: const Text(
                      "Are you sure you want to delete all history?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        child: const Text("Cancel"),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await HistoryService.clearHistory();

                          if (!dialogContext.mounted) return;

                          Navigator.pop(dialogContext);

                          if (!context.mounted) return;

                          _loadHistory(); // 🔄 लिस्ट रीफ्रेश करें

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("History cleared"),
                            ),
                          );
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // 🎯 Search Bar UI
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search prompts...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchText = "";
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: history.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_toggle_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No Prompt History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : filteredHistory.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No matching prompts found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                final item = filteredHistory[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(item.title),
                          content: SingleChildScrollView(
                            child: SelectableText(item.prompt),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 🎯 Subtitle: Prompt text और Date/Time दिखाने के लिए
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item.prompt,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          DateFormat('dd MMM yyyy • hh:mm a')
                              .format(item.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    // 🎯 Trailing: Favorite बटन और Three Dots Menu
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1. Favorite Button
                        IconButton(
                          icon: Icon(
                            item.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: item.isFavorite
                                ? Colors.red
                                : Colors.grey,
                          ),
                          tooltip: item.isFavorite
                              ? "Remove from Favorites"
                              : "Add to Favorites",
                          onPressed: () async {
                            await HistoryService.toggleFavoriteByItem(
                                item);
                            _loadHistory(); // 🔄 लिस्ट रीफ्रेश करें
                          },
                        ),

                        // 2. Popup Menu (onSelected को async किया गया)
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            if (value == 'share') {
                              final fullText = "${item.title}\n\n${item.prompt}";
                              await SharePlus.instance.share(
                                ShareParams(
                                  text: fullText,
                                ),
                              );
                            } else if (value == 'copy') {
                              Clipboard.setData(
                                ClipboardData(text: item.prompt),
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Prompt Copied Successfully!"),
                                ),
                              );
                            } else if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (dialogContext) =>
                                    AlertDialog(
                                      title:
                                      const Text("Delete Prompt?"),
                                      content: const Text(
                                        "Are you sure you want to delete this prompt?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(dialogContext),
                                          child: const Text("Cancel"),
                                        ),
                                        FilledButton(
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor:
                                            Colors.white,
                                          ),
                                          onPressed: () async {
                                            await HistoryService
                                                .deletePromptByItem(
                                                item);

                                            if (!dialogContext.mounted) return;

                                            Navigator.pop(dialogContext);

                                            if (!context.mounted) return;

                                            _loadHistory(); // 🔄 लिस्ट रीफ्रेश करें
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'share',
                              child: Row(
                                children: [
                                  Icon(Icons.share,
                                      color: Colors.green, size: 20),
                                  SizedBox(width: 10),
                                  Text("Share"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'copy',
                              child: Row(
                                children: [
                                  Icon(Icons.copy,
                                      color: Colors.blue, size: 20),
                                  SizedBox(width: 10),
                                  Text("Copy"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      color: Colors.red, size: 20),
                                  SizedBox(width: 10),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                          ],
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
  }
}