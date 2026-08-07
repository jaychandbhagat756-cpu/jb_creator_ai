enum MessageRole {
  user,
  assistant,
  system,
}

class ChatMessage {
  final String id;
  final String text;
  final MessageRole role;
  final DateTime createdAt;
  final bool isError;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.role,
    required this.createdAt,
    this.isError = false,
  });

  bool get isUser => role == MessageRole.user;

  bool get isAssistant => role == MessageRole.assistant;

  bool get isSystem => role == MessageRole.system;

  ChatMessage copyWith({
    String? id,
    String? text,
    MessageRole? role,
    DateTime? createdAt,
    bool? isError,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isError: isError ?? this.isError,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "role": role.name,
      "createdAt": createdAt.toIso8601String(),
      "isError": isError,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json["id"] as String,
      text: json["text"] as String,
      role: MessageRole.values.firstWhere(
            (e) => e.name == json["role"],
        orElse: () => MessageRole.user,
      ),
      createdAt: DateTime.parse(json["createdAt"]),
      isError: json["isError"] ?? false,
    );
  }
}