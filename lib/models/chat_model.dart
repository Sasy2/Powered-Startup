class ChatMessage {
  final String id;
  final String userId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isFromUser;
  final String? audioUrl;
  final List<ChatAction>? actions;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.isFromUser,
    this.audioUrl,
    this.actions,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      isFromUser: map['isFromUser'] ?? false,
      audioUrl: map['audioUrl'],
      actions: (map['actions'] as List<dynamic>?)
          ?.map((a) => ChatAction.fromMap(a))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isFromUser': isFromUser,
      'audioUrl': audioUrl,
      'actions': actions?.map((a) => a.toMap()).toList(),
    };
  }
}

enum MessageType {
  text,
  audio,
  image,
  action,
  suggestion,
}

class ChatAction {
  final String id;
  final String title;
  final String type;
  final Map<String, dynamic>? data;

  ChatAction({
    required this.id,
    required this.title,
    required this.type,
    this.data,
  });

  factory ChatAction.fromMap(Map<String, dynamic> map) {
    return ChatAction(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      data: map['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'data': data,
    };
  }
}

class ChatSession {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<ChatMessage> messages;
  final String? summary;
  final ChatStatus status;

  ChatSession({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.messages,
    this.summary,
    this.status = ChatStatus.active,
  });

  factory ChatSession.fromMap(Map<String, dynamic> map) {
    return ChatSession(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      startTime: DateTime.parse(map['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      messages: (map['messages'] as List<dynamic>?)
          ?.map((m) => ChatMessage.fromMap(m))
          .toList() ?? [],
      summary: map['summary'],
      status: ChatStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => ChatStatus.active,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'messages': messages.map((m) => m.toMap()).toList(),
      'summary': summary,
      'status': status.toString(),
    };
  }
}

enum ChatStatus {
  active,
  ended,
  paused,
}

class AIRecommendation {
  final String id;
  final String userId;
  final String title;
  final String description;
  final RecommendationType type;
  final int priority; // 1-5 scale
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  AIRecommendation({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    required this.createdAt,
    this.isRead = false,
    this.metadata,
  });

  factory AIRecommendation.fromMap(Map<String, dynamic> map) {
    return AIRecommendation(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: RecommendationType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => RecommendationType.exercise,
      ),
      priority: map['priority'] ?? 1,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      isRead: map['isRead'] ?? false,
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type.toString(),
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'metadata': metadata,
    };
  }
}

enum RecommendationType {
  exercise,
  test,
  rest,
  consultation,
  lifestyle,
  medication,
}

