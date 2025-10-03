/// Exercise category enumeration
enum ExerciseCategory {
  relaxation,
  migraineRelief,
  focusTraining,
  screenStrainRelief,
}

/// Exercise difficulty levels
enum ExerciseDifficulty {
  beginner,
  intermediate,
  advanced,
}

/// Exercise completion status
enum ExerciseStatus {
  notStarted,
  inProgress,
  completed,
  skipped,
}

/// Main exercise model
class Exercise {
  final String id;
  final String name;
  final String description;
  final String instructions;
  final ExerciseCategory category;
  final ExerciseDifficulty difficulty;
  final int durationSeconds;
  final List<String> benefits;
  final String iconName;
  final bool hasAnimation;
  final bool hasVoice;
  final List<String> tags;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.category,
    required this.difficulty,
    required this.durationSeconds,
    required this.benefits,
    required this.iconName,
    this.hasAnimation = true,
    this.hasVoice = true,
    this.tags = const [],
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      instructions: map['instructions'] ?? '',
      category: ExerciseCategory.values.firstWhere(
        (e) => e.toString().split('.').last == map['category'],
        orElse: () => ExerciseCategory.relaxation,
      ),
      difficulty: ExerciseDifficulty.values.firstWhere(
        (e) => e.toString().split('.').last == map['difficulty'],
        orElse: () => ExerciseDifficulty.beginner,
      ),
      durationSeconds: map['duration_seconds'] ?? 60,
      benefits: List<String>.from(map['benefits'] ?? []),
      iconName: map['icon_name'] ?? 'fitness_center',
      hasAnimation: map['has_animation'] ?? true,
      hasVoice: map['has_voice'] ?? true,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'instructions': instructions,
      'category': category.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'duration_seconds': durationSeconds,
      'benefits': benefits,
      'icon_name': iconName,
      'has_animation': hasAnimation,
      'has_voice': hasVoice,
      'tags': tags,
    };
  }

  String get categoryDisplayName {
    switch (category) {
      case ExerciseCategory.relaxation:
        return 'Relaxation';
      case ExerciseCategory.migraineRelief:
        return 'Migraine Relief';
      case ExerciseCategory.focusTraining:
        return 'Focus Training';
      case ExerciseCategory.screenStrainRelief:
        return 'Screen Strain Relief';
    }
  }

  String get difficultyDisplayName {
    switch (difficulty) {
      case ExerciseDifficulty.beginner:
        return 'Beginner';
      case ExerciseDifficulty.intermediate:
        return 'Intermediate';
      case ExerciseDifficulty.advanced:
        return 'Advanced';
    }
  }

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}

/// Exercise session model
class ExerciseSession {
  final String id;
  final String userId;
  final String exerciseId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final ExerciseStatus status;
  final Map<String, dynamic> sessionData;
  final int? score;
  final String? feedback;

  ExerciseSession({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    required this.status,
    this.sessionData = const {},
    this.score,
    this.feedback,
  });

  factory ExerciseSession.fromMap(Map<String, dynamic> map) {
    return ExerciseSession(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      exerciseId: map['exercise_id'] ?? '',
      startTime: DateTime.parse(map['start_time'] ?? DateTime.now().toIso8601String()),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
      durationSeconds: map['duration_seconds'] ?? 0,
      status: ExerciseStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => ExerciseStatus.notStarted,
      ),
      sessionData: Map<String, dynamic>.from(map['session_data'] ?? {}),
      score: map['score'],
      feedback: map['feedback'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'exercise_id': exerciseId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'duration_seconds': durationSeconds,
      'status': status.toString().split('.').last,
      'session_data': sessionData,
      'score': score,
      'feedback': feedback,
    };
  }

  bool get isCompleted => status == ExerciseStatus.completed;
  bool get isInProgress => status == ExerciseStatus.inProgress;
  
  Duration? get actualDuration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return null;
  }
}

/// Daily exercise plan model
class DailyExercisePlan {
  final String id;
  final String userId;
  final DateTime date;
  final List<String> suggestedExerciseIds;
  final List<String> completedExerciseIds;
  final int streak;
  final bool isCompleted;
  final Map<String, dynamic> metadata;

  DailyExercisePlan({
    required this.id,
    required this.userId,
    required this.date,
    required this.suggestedExerciseIds,
    this.completedExerciseIds = const [],
    this.streak = 0,
    this.isCompleted = false,
    this.metadata = const {},
  });

  factory DailyExercisePlan.fromMap(Map<String, dynamic> map) {
    return DailyExercisePlan(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      suggestedExerciseIds: List<String>.from(map['suggested_exercise_ids'] ?? []),
      completedExerciseIds: List<String>.from(map['completed_exercise_ids'] ?? []),
      streak: map['streak'] ?? 0,
      isCompleted: map['is_completed'] ?? false,
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'suggested_exercise_ids': suggestedExerciseIds,
      'completed_exercise_ids': completedExerciseIds,
      'streak': streak,
      'is_completed': isCompleted,
      'metadata': metadata,
    };
  }

  double get completionPercentage {
    if (suggestedExerciseIds.isEmpty) return 0.0;
    return completedExerciseIds.length / suggestedExerciseIds.length;
  }

  bool get isFullyCompleted => completedExerciseIds.length >= suggestedExerciseIds.length;
}

/// User progress statistics
class ExerciseProgress {
  final String userId;
  final int totalSessions;
  final int totalMinutes;
  final int currentStreak;
  final int longestStreak;
  final Map<ExerciseCategory, int> categoryCounts;
  final Map<String, int> exerciseCounts;
  final List<Achievement> achievements;
  final DateTime lastActivity;

  ExerciseProgress({
    required this.userId,
    required this.totalSessions,
    required this.totalMinutes,
    required this.currentStreak,
    required this.longestStreak,
    required this.categoryCounts,
    required this.exerciseCounts,
    required this.achievements,
    required this.lastActivity,
  });

  factory ExerciseProgress.fromMap(Map<String, dynamic> map) {
    return ExerciseProgress(
      userId: map['user_id'] ?? '',
      totalSessions: map['total_sessions'] ?? 0,
      totalMinutes: map['total_minutes'] ?? 0,
      currentStreak: map['current_streak'] ?? 0,
      longestStreak: map['longest_streak'] ?? 0,
      categoryCounts: Map<ExerciseCategory, int>.from(
        (map['category_counts'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(
            ExerciseCategory.values.firstWhere(
              (e) => e.toString().split('.').last == key,
              orElse: () => ExerciseCategory.relaxation,
            ),
            value as int,
          ),
        ) ?? {},
      ),
      exerciseCounts: Map<String, int>.from(map['exercise_counts'] ?? {}),
      achievements: (map['achievements'] as List<dynamic>?)
          ?.map((a) => Achievement.fromMap(a))
          .toList() ?? [],
      lastActivity: DateTime.parse(map['last_activity'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'total_sessions': totalSessions,
      'total_minutes': totalMinutes,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'category_counts': categoryCounts.map(
        (key, value) => MapEntry(key.toString().split('.').last, value),
      ),
      'exercise_counts': exerciseCounts,
      'achievements': achievements.map((a) => a.toMap()).toList(),
      'last_activity': lastActivity.toIso8601String(),
    };
  }
}

/// Achievement model
class Achievement {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final DateTime unlockedAt;
  final Map<String, dynamic> criteria;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.unlockedAt,
    this.criteria = const {},
  });

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      iconName: map['icon_name'] ?? 'star',
      unlockedAt: DateTime.parse(map['unlocked_at'] ?? DateTime.now().toIso8601String()),
      criteria: Map<String, dynamic>.from(map['criteria'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_name': iconName,
      'unlocked_at': unlockedAt.toIso8601String(),
      'criteria': criteria,
    };
  }
}

/// Exercise animation configuration
class ExerciseAnimationConfig {
  final String type; // 'dot', 'line', 'figure8', 'radial', 'text'
  final Map<String, dynamic> parameters;
  final int durationMs;
  final bool loop;
  final String? audioPrompt;

  ExerciseAnimationConfig({
    required this.type,
    required this.parameters,
    required this.durationMs,
    this.loop = true,
    this.audioPrompt,
  });

  factory ExerciseAnimationConfig.fromMap(Map<String, dynamic> map) {
    return ExerciseAnimationConfig(
      type: map['type'] ?? 'dot',
      parameters: Map<String, dynamic>.from(map['parameters'] ?? {}),
      durationMs: map['duration_ms'] ?? 5000,
      loop: map['loop'] ?? true,
      audioPrompt: map['audio_prompt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'parameters': parameters,
      'duration_ms': durationMs,
      'loop': loop,
      'audio_prompt': audioPrompt,
    };
  }
}
