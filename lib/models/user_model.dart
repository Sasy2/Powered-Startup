class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final UserPreferences preferences;
  final UserStats stats;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
    required this.lastLoginAt,
    required this.preferences,
    required this.stats,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLoginAt: DateTime.parse(map['lastLoginAt'] ?? DateTime.now().toIso8601String()),
      preferences: UserPreferences.fromMap(map['preferences'] ?? {}),
      stats: UserStats.fromMap(map['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'preferences': preferences.toMap(),
      'stats': stats.toMap(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserPreferences? preferences,
    UserStats? stats,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }
}

class UserPreferences {
  final bool darkMode;
  final String language;
  final bool notificationsEnabled;
  final bool voiceEnabled;
  final int reminderInterval; // in minutes

  UserPreferences({
    this.darkMode = false,
    this.language = 'en',
    this.notificationsEnabled = true,
    this.voiceEnabled = true,
    this.reminderInterval = 60,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      darkMode: map['darkMode'] ?? false,
      language: map['language'] ?? 'en',
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      voiceEnabled: map['voiceEnabled'] ?? true,
      reminderInterval: map['reminderInterval'] ?? 60,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'voiceEnabled': voiceEnabled,
      'reminderInterval': reminderInterval,
    };
  }
}

class UserStats {
  final int totalVisionTests;
  final int totalExercisesCompleted;
  final int currentStreak;
  final int longestStreak;
  final double averageScreenTime; // in hours
  final DateTime lastVisionTest;
  final DateTime lastExercise;

  UserStats({
    this.totalVisionTests = 0,
    this.totalExercisesCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.averageScreenTime = 0.0,
    required this.lastVisionTest,
    required this.lastExercise,
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalVisionTests: map['totalVisionTests'] ?? 0,
      totalExercisesCompleted: map['totalExercisesCompleted'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      averageScreenTime: (map['averageScreenTime'] ?? 0.0).toDouble(),
      lastVisionTest: DateTime.parse(map['lastVisionTest'] ?? DateTime.now().toIso8601String()),
      lastExercise: DateTime.parse(map['lastExercise'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalVisionTests': totalVisionTests,
      'totalExercisesCompleted': totalExercisesCompleted,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'averageScreenTime': averageScreenTime,
      'lastVisionTest': lastVisionTest.toIso8601String(),
      'lastExercise': lastExercise.toIso8601String(),
    };
  }
}

