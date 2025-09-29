class ExerciseModel {
  final String id;
  final String name;
  final String description;
  final String instructions;
  final int duration; // in minutes
  final ExerciseType type;
  final DifficultyLevel difficulty;
  final String? videoUrl;
  final String? imageUrl;
  final List<String> benefits;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.duration,
    required this.type,
    required this.difficulty,
    this.videoUrl,
    this.imageUrl,
    required this.benefits,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      instructions: map['instructions'] ?? '',
      duration: map['duration'] ?? 5,
      type: ExerciseType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => ExerciseType.focus,
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.toString() == map['difficulty'],
        orElse: () => DifficultyLevel.beginner,
      ),
      videoUrl: map['videoUrl'],
      imageUrl: map['imageUrl'],
      benefits: List<String>.from(map['benefits'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'instructions': instructions,
      'duration': duration,
      'type': type.toString(),
      'difficulty': difficulty.toString(),
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'benefits': benefits,
    };
  }
}

enum ExerciseType {
  focus,
  relaxation,
  strength,
  flexibility,
  coordination,
  breathing,
}

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
}

class ExerciseSession {
  final String id;
  final String userId;
  final String exerciseId;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration; // in seconds
  final bool isCompleted;
  final int repetitions;
  final String? notes;

  ExerciseSession({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.startTime,
    this.endTime,
    required this.duration,
    this.isCompleted = false,
    this.repetitions = 1,
    this.notes,
  });

  factory ExerciseSession.fromMap(Map<String, dynamic> map) {
    return ExerciseSession(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      exerciseId: map['exerciseId'] ?? '',
      startTime: DateTime.parse(map['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      duration: map['duration'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      repetitions: map['repetitions'] ?? 1,
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'exerciseId': exerciseId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'isCompleted': isCompleted,
      'repetitions': repetitions,
      'notes': notes,
    };
  }
}

class DailyPlan {
  final String id;
  final String userId;
  final DateTime date;
  final List<PlannedExercise> exercises;
  final int completedExercises;
  final double progress; // 0.0 to 1.0
  final String? aiRecommendation;

  DailyPlan({
    required this.id,
    required this.userId,
    required this.date,
    required this.exercises,
    this.completedExercises = 0,
    this.progress = 0.0,
    this.aiRecommendation,
  });

  factory DailyPlan.fromMap(Map<String, dynamic> map) {
    return DailyPlan(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      exercises: (map['exercises'] as List<dynamic>?)
          ?.map((e) => PlannedExercise.fromMap(e))
          .toList() ?? [],
      completedExercises: map['completedExercises'] ?? 0,
      progress: (map['progress'] ?? 0.0).toDouble(),
      aiRecommendation: map['aiRecommendation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'completedExercises': completedExercises,
      'progress': progress,
      'aiRecommendation': aiRecommendation,
    };
  }
}

class PlannedExercise {
  final String exerciseId;
  final int repetitions;
  final int duration; // in minutes
  final bool isCompleted;
  final DateTime? completedAt;

  PlannedExercise({
    required this.exerciseId,
    required this.repetitions,
    required this.duration,
    this.isCompleted = false,
    this.completedAt,
  });

  factory PlannedExercise.fromMap(Map<String, dynamic> map) {
    return PlannedExercise(
      exerciseId: map['exerciseId'] ?? '',
      repetitions: map['repetitions'] ?? 1,
      duration: map['duration'] ?? 5,
      isCompleted: map['isCompleted'] ?? false,
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'repetitions': repetitions,
      'duration': duration,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

