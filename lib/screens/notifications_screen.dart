import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const notifications = <_NotificationItem>[
      _NotificationItem(
        icon: Icons.auto_awesome,
        title: 'Welcome to JB Creator AI',
        message: 'Your AI creator workspace is ready. Start creating your next project.',
        time: 'Just now',
        isNew: true,
      ),
      _NotificationItem(
        icon: Icons.lightbulb_outline,
        title: 'Create faster with AI Tools',
        message: 'Use AI Chat, Lyrics, SEO, Script, Music and Video Prompt tools from one place.',
        time: 'Today',
        isNew: true,
      ),
      _NotificationItem(
        icon: Icons.folder_open_outlined,
        title: 'Your projects are safe',
        message: 'Your projects are stored locally and can be opened anytime from Recent Projects.',
        time: 'Today',
        isNew: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        itemCount: notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _NotificationCard(item: notifications[index]);
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: primary.withValues(alpha: 0.10),
              ),
              child: Icon(item.icon, color: primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (item.isNew)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.time,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final bool isNew;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.isNew,
  });
}
