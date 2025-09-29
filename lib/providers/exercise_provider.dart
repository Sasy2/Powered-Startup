import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';
import '../services/firebase_service.dart';

class ExerciseProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<ExerciseModel> _exercises = [];
  List<ExerciseSession> _sessions = [];
  DailyPlan? _todayPlan;
  bool _isLoading = false;
  String? _error;

  List<ExerciseModel> get exercises => _exercises;
  List<ExerciseSession> get sessions => _sessions;
  DailyPlan? get todayPlan => _todayPlan;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExercises() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _exercises = await _firebaseService.getExercises();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserSessions(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sessions = await _firebaseService.getUserExerciseSessions(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTodayPlan(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todayPlan = await _firebaseService.getDailyPlan(userId, DateTime.now());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startExerciseSession(String userId, String exerciseId) async {
    try {
      final session = ExerciseSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        exerciseId: exerciseId,
        startTime: DateTime.now(),
        duration: 0,
      );
      
      await _firebaseService.saveExerciseSession(session);
      _sessions.insert(0, session);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> completeExerciseSession(String sessionId, int duration, {String? notes}) async {
    try {
      final sessionIndex = _sessions.indexWhere((s) => s.id == sessionId);
      if (sessionIndex != -1) {
        final updatedSession = _sessions[sessionIndex].copyWith(
          endTime: DateTime.now(),
          duration: duration,
          isCompleted: true,
          notes: notes,
        );
        
        await _firebaseService.saveExerciseSession(updatedSession);
        _sessions[sessionIndex] = updatedSession;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> createDailyPlan(String userId, List<PlannedExercise> exercises, {String? aiRecommendation}) async {
    try {
      final plan = DailyPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        date: DateTime.now(),
        exercises: exercises,
        aiRecommendation: aiRecommendation,
      );
      
      await _firebaseService.saveDailyPlan(plan);
      _todayPlan = plan;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> completePlannedExercise(String exerciseId) async {
    if (_todayPlan == null) return;

    try {
      final updatedExercises = _todayPlan!.exercises.map((exercise) {
        if (exercise.exerciseId == exerciseId) {
          return PlannedExercise(
            exerciseId: exercise.exerciseId,
            repetitions: exercise.repetitions,
            duration: exercise.duration,
            isCompleted: true,
            completedAt: DateTime.now(),
          );
        }
        return exercise;
      }).toList();

      final completedCount = updatedExercises.where((e) => e.isCompleted).length;
      final progress = completedCount / updatedExercises.length;

      final updatedPlan = DailyPlan(
        id: _todayPlan!.id,
        userId: _todayPlan!.userId,
        date: _todayPlan!.date,
        exercises: updatedExercises,
        completedExercises: completedCount,
        progress: progress,
        aiRecommendation: _todayPlan!.aiRecommendation,
      );

      await _firebaseService.saveDailyPlan(updatedPlan);
      _todayPlan = updatedPlan;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<ExerciseModel> getExercisesByType(ExerciseType type) {
    return _exercises.where((exercise) => exercise.type == type).toList();
  }

  List<ExerciseModel> getExercisesByDifficulty(DifficultyLevel difficulty) {
    return _exercises.where((exercise) => exercise.difficulty == difficulty).toList();
  }

  ExerciseModel? getExerciseById(String exerciseId) {
    try {
      return _exercises.firstWhere((exercise) => exercise.id == exerciseId);
    } catch (e) {
      return null;
    }
  }

  int getTodayCompletedExercises() {
    if (_todayPlan == null) return 0;
    return _todayPlan!.exercises.where((e) => e.isCompleted).length;
  }

  double getTodayProgress() {
    if (_todayPlan == null || _todayPlan!.exercises.isEmpty) return 0.0;
    return _todayPlan!.progress;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

extension ExerciseSessionExtension on ExerciseSession {
  ExerciseSession copyWith({
    String? id,
    String? userId,
    String? exerciseId,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    bool? isCompleted,
    int? repetitions,
    String? notes,
  }) {
    return ExerciseSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseId: exerciseId ?? this.exerciseId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
      repetitions: repetitions ?? this.repetitions,
      notes: notes ?? this.notes,
    );
  }
}

