/// 聊天消息模型
class ChatMessage {
  final int id;
  final int senderId;
  final String senderName;
  final String? senderAvatar;
  final int receiverId;
  final String receiverName;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final bool isFiltered;
  final String? filteredContent;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.receiverId,
    required this.receiverName,
    required this.content,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.isFiltered = false,
    this.filteredContent,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      senderName: json['sender_name'] ?? '',
      senderAvatar: json['sender_avatar'],
      receiverId: json['receiver_id'] ?? 0,
      receiverName: json['receiver_name'] ?? '',
      content: json['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      isFiltered: json['is_filtered'] ?? false,
      filteredContent: json['filtered_content'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'content': content,
      'type': type.name,
      'status': status.name,
      'is_filtered': isFiltered,
      'filtered_content': filteredContent,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChatMessage copyWith({
    int? id,
    int? senderId,
    String? senderName,
    String? senderAvatar,
    int? receiverId,
    String? receiverName,
    String? content,
    MessageType? type,
    MessageStatus? status,
    bool? isFiltered,
    String? filteredContent,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      isFiltered: isFiltered ?? this.isFiltered,
      filteredContent: filteredContent ?? this.filteredContent,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum MessageType {
  text,
  image,
  location,
  system,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
  filtered,
}

/// 对话模型
class Conversation {
  final int id;
  final int userId1;
  final int userId2;
  final String user1Name;
  final String? user1Avatar;
  final String user2Name;
  final String? user2Avatar;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.userId1,
    required this.userId2,
    required this.user1Name,
    this.user1Avatar,
    required this.user2Name,
    this.user2Avatar,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? 0,
      userId1: json['user_id_1'] ?? 0,
      userId2: json['user_id_2'] ?? 0,
      user1Name: json['user1_name'] ?? '',
      user1Avatar: json['user1_avatar'],
      user2Name: json['user2_name'] ?? '',
      user2Avatar: json['user2_avatar'],
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id_1': userId1,
      'user_id_2': userId2,
      'user1_name': user1Name,
      'user1_avatar': user1Avatar,
      'user2_name': user2Name,
      'user2_avatar': user2Avatar,
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
