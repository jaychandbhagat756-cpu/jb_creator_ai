import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              radius: 18,
              child: Icon(Icons.smart_toy),
            ),

          if (!isUser)
            const SizedBox(width: 8),

          Flexible(
            child: Container(
              padding:
              const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: message.isError
                    ? Colors.red.shade100
                    : isUser
                    ? Colors.blue
                    : Colors.grey.shade200,
                borderRadius:
                BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    message.text,
                    textWidthBasis: TextWidthBasis.parent,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(
                          message.createdAt,
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          color: isUser
                              ? Colors.white70
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: message.text,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(
                                "Copied",
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.copy,
                          size: 18,
                          color: isUser
                              ? Colors.white70
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (isUser)
            const SizedBox(width: 8),

          if (isUser)
            const CircleAvatar(
              radius: 18,
              child: Icon(Icons.person),
            ),
        ],
      ),
    );
  }

  String _formatTime(
      DateTime dateTime,
      ) {
    final hour =
    dateTime.hour
        .toString()
        .padLeft(2, '0');

    final minute =
    dateTime.minute
        .toString()
        .padLeft(2, '0');

    return "$hour:$minute";
  }
}