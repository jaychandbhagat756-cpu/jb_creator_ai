import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
    required this.onNewChat,
    required this.onClearChat,
  });

  final VoidCallback onNewChat;
  final VoidCallback onClearChat;

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,

      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircleAvatar(
            radius: 16,
            child: Icon(
              Icons.smart_toy,
              size: 18,
            ),
          ),
          SizedBox(width: 10),
          Text(
            "JB Creator AI",
          ),
        ],
      ),

      actions: [

        PopupMenuButton<String>(

          onSelected: (value) {

            switch (value) {

              case "new":
                onNewChat();
                break;

              case "clear":
                onClearChat();
                break;

            }

          },

          itemBuilder: (context) => const [

            PopupMenuItem(
              value: "new",
              child: Row(
                children: [
                  Icon(Icons.add_comment),
                  SizedBox(width: 10),
                  Text("New Chat"),
                ],
              ),
            ),

            PopupMenuItem(
              value: "clear",
              child: Row(
                children: [
                  Icon(Icons.delete_outline),
                  SizedBox(width: 10),
                  Text("Clear Chat"),
                ],
              ),
            ),

          ],

        ),

      ],

    );
  }
}