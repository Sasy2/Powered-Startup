import 'package:flutter/widgets.dart';
import '../models/exercise_models.dart';
import '../services/exercise_library.dart';

/// Provider for managing exercise state and progress
class ExerciseProvider with ChangeNotifier {
  // Current state
  List<Exercise> _allExercises = [];
  List<Exercise> _dailySuggestions = [];
  DailyExercisePlan? _currentPlan;
  ExerciseProgress? _userProgress;
  ExerciseSession? _currentSession;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Exercise> get allExercises => _allExercises;
  List<Exercise> get dailySuggestions => _dailySuggestions;
  DailyExercisePlan? get currentPlan => _currentPlan;
  ExerciseProgress? get userProgress => _userProgress;
  ExerciseSession? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize the exercise provider
  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load all exercises
      _allExercises = ExerciseLibrary.getAllExercises();
      
      // Generate daily suggestions
      await _generateDailySuggestions();
      
      // Load user progress (in a real app, this would come from a database)
      await _loadUserProgress();
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generate daily exercise suggestions
  Future<void> _generateDailySuggestions() async {
    try {
      // Check if we already have a plan for today
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      if (_currentPlan != null && _currentPlan!.date.toIso8601String().startsWith(todayString)) {
        // Use existing plan
        _dailySuggestions = _currentPlan!.suggestedExerciseIds
            .map((id) => ExerciseLibrary.getExerciseById(id))
            .where((exercise) => exercise != null)
            .cast<Exercise>()
            .toList();
      } else {
        // Generate new plan
        _dailySuggestions = ExerciseLibrary.getDailySuggestions();
        
        _currentPlan = DailyExercisePlan(
          id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
          userId: 'demo_user', // In a real app, this would be the actual user ID
          date: today,
          suggestedExerciseIds: _dailySuggestions.map((e) => e.id).toList(),
        );
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Load user progress
  Future<void> _loadUserProgress() async {
    try {
      // In a real app, this would load from a database
      _userProgress = ExerciseProgress(
        userId: 'demo_user',
        totalSessions: 0,
        totalMinutes: 0,
        currentStreak: 0,
        longestStreak: 0,
        categoryCounts: {},
        exerciseCounts: {},
        achievements: [],
        lastActivity: DateTime.now(),
      );
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Get exercises by category
  List<Exercise> getExercisesByCategory(ExerciseCategory category) {
    return ExerciseLibrary.getExercisesByCategory(category);
  }

  /// Get exercises by difficulty
  List<Exercise> getExercisesByDifficulty(ExerciseDifficulty difficulty) {
    return ExerciseLibrary.getExercisesByDifficulty(difficulty);
  }

  /// Search exercises
  List<Exercise> searchExercises(String query) {
    return ExerciseLibrary.searchExercises(query);
  }

  /// Start an exercise session
  Future<void> startExerciseSession(String exerciseId) async {
    try {
      final exercise = ExerciseLibrary.getExerciseById(exerciseId);
      if (exercise == null) {
        _error = 'Exercise not found';
        notifyListeners();
        return;
      }

      _currentSession = ExerciseSession(
        id: 'session_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'demo_user',
        exerciseId: exerciseId,
        startTime: DateTime.now(),
        durationSeconds: exercise.durationSeconds,
        status: ExerciseStatus.inProgress,
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Complete an exercise session
  Future<void> completeExerciseSession({int? score, String? feedback}) async {
    if (_currentSession == null) return;

    try {
      _currentSession = ExerciseSession(
        id: _currentSession!.id,
        userId: _currentSession!.userId,
        exerciseId: _currentSession!.exerciseId,
        startTime: _currentSession!.startTime,
        endTime: DateTime.now(),
        durationSeconds: _currentSession!.durationSeconds,
        status: ExerciseStatus.completed,
        sessionData: _currentSession!.sessionData,
        score: score,
        feedback: feedback,
      );

      // Update progress
      await _updateProgress(_currentSession!);
      
      // Update daily plan
      await _updateDailyPlan(_currentSession!.exerciseId);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Skip an exercise session
  Future<void> skipExerciseSession() async {
    if (_currentSession == null) return;

    try {
      _currentSession = ExerciseSession(
        id: _currentSession!.id,
        userId: _currentSession!.userId,
        exerciseId: _currentSession!.exerciseId,
        startTime: _currentSession!.startTime,
        endTime: DateTime.now(),
        durationSeconds: _currentSession!.durationSeconds,
        status: ExerciseStatus.skipped,
        sessionData: _currentSession!.sessionData,
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Update user progress
  Future<void> _updateProgress(ExerciseSession session) async {
    if (_userProgress == null) return;

    try {
      final exercise = ExerciseLibrary.getExerciseById(session.exerciseId);
      if (exercise == null) return;

      // Update session count
      final newTotalSessions = _userProgress!.totalSessions + 1;
      
      // Update total minutes
      final sessionMinutes = session.actualDuration?.inMinutes ?? (session.durationSeconds ~/ 60);
      final newTotalMinutes = _userProgress!.totalMinutes + sessionMinutes;
      
      // Update category counts
      final newCategoryCounts = Map<ExerciseCategory, int>.from(_userProgress!.categoryCounts);
      newCategoryCounts[exercise.category] = (newCategoryCounts[exercise.category] ?? 0) + 1;
      
      // Update exercise counts
      final newExerciseCounts = Map<String, int>.from(_userProgress!.exerciseCounts);
      newExerciseCounts[exercise.id] = (newExerciseCounts[exercise.id] ?? 0) + 1;
      
      // Update streak (simplified - in a real app, this would check consecutive days)
      final newCurrentStreak = _userProgress!.currentStreak + 1;
      final newLongestStreak = newCurrentStreak > _userProgress!.longestStreak 
          ? newCurrentStreak 
          : _userProgress!.longestStreak;

      _userProgress = ExerciseProgress(
        userId: _userProgress!.userId,
        totalSessions: newTotalSessions,
        totalMinutes: newTotalMinutes,
        currentStreak: newCurrentStreak,
        longestStreak: newLongestStreak,
        categoryCounts: newCategoryCounts,
        exerciseCounts: newExerciseCounts,
        achievements: _userProgress!.achievements,
        lastActivity: DateTime.now(),
      );

      // Check for new achievements
      await _checkAchievements();
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Update daily plan
  Future<void> _updateDailyPlan(String exerciseId) async {
    if (_currentPlan == null) return;

    try {
      final newCompletedIds = List<String>.from(_currentPlan!.completedExerciseIds);
      if (!newCompletedIds.contains(exerciseId)) {
        newCompletedIds.add(exerciseId);
      }

      final isCompleted = newCompletedIds.length >= _currentPlan!.suggestedExerciseIds.length;

      _currentPlan = DailyExercisePlan(
        id: _currentPlan!.id,
        userId: _currentPlan!.userId,
        date: _currentPlan!.date,
        suggestedExerciseIds: _currentPlan!.suggestedExerciseIds,
        completedExerciseIds: newCompletedIds,
        streak: _currentPlan!.streak,
        isCompleted: isCompleted,
        metadata: _currentPlan!.metadata,
      );
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Check for new achievements
  Future<void> _checkAchievements() async {
    if (_userProgress == null) return;

    try {
      final newAchievements = <Achievement>[];
      
      // First exercise achievement
      if (_userProgress!.totalSessions == 1) {
        newAchievements.add(Achievement(
          id: 'first_exercise',
          name: 'First Steps',
          description: 'Completed your first exercise!',
          iconName: 'star',
          unlockedAt: DateTime.now(),
          criteria: {'total_sessions': 1},
        ));
      }
      
      // 10 exercises achievement
      if (_userProgress!.totalSessions == 10) {
        newAchievements.add(Achievement(
          id: 'ten_exercises',
          name: 'Getting Stronger',
          description: 'Completed 10 exercises!',
          iconName: 'fitness_center',
          unlockedAt: DateTime.now(),
          criteria: {'total_sessions': 10},
        ));
      }
      
      // 7-day streak achievement
      if (_userProgress!.currentStreak == 7) {
        newAchievements.add(Achievement(
          id: 'week_streak',
          name: 'Week Warrior',
          description: '7-day exercise streak!',
          iconName: 'local_fire_department',
          unlockedAt: DateTime.now(),
          criteria: {'streak': 7},
        ));
      }
      
      // Add new achievements to the list
      if (newAchievements.isNotEmpty) {
        final updatedAchievements = List<Achievement>.from(_userProgress!.achievements);
        updatedAchievements.addAll(newAchievements);
        
        _userProgress = ExerciseProgress(
          userId: _userProgress!.userId,
          totalSessions: _userProgress!.totalSessions,
          totalMinutes: _userProgress!.totalMinutes,
          currentStreak: _userProgress!.currentStreak,
          longestStreak: _userProgress!.longestStreak,
          categoryCounts: _userProgress!.categoryCounts,
          exerciseCounts: _userProgress!.exerciseCounts,
          achievements: updatedAchievements,
          lastActivity: _userProgress!.lastActivity,
        );
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Get recommended exercises
  List<Exercise> getRecommendedExercises({int limit = 5}) {
    if (_userProgress == null) return [];
    return ExerciseLibrary.getRecommendedExercises(_userProgress!.exerciseCounts, limit: limit);
  }

  /// Get exercise animation configuration
  ExerciseAnimationConfig getAnimationConfig(String exerciseId) {
    return ExerciseLibrary.getAnimationConfig(exerciseId);
  }

  /// Refresh daily suggestions
  Future<void> refreshDailySuggestions() async {
    await _generateDailySuggestions();
    notifyListeners();
  }

  /// Clear current session
  void clearCurrentSession() {
    _currentSession = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get completion percentage for daily plan
  double getDailyCompletionPercentage() {
    if (_currentPlan == null || _currentPlan!.suggestedExerciseIds.isEmpty) return 0.0;
    return _currentPlan!.completionPercentage;
  }

  /// Check if daily plan is completed
  bool isDailyPlanCompleted() {
    return _currentPlan?.isFullyCompleted ?? false;
  }

  /// Get remaining exercises for today
  List<Exercise> getRemainingExercises() {
    if (_currentPlan == null) return [];
    
    final completedIds = _currentPlan!.completedExerciseIds;
    return _currentPlan!.suggestedExerciseIds
        .where((id) => !completedIds.contains(id))
        .map((id) => ExerciseLibrary.getExerciseById(id))
        .where((exercise) => exercise != null)
        .cast<Exercise>()
        .toList();
  }
}
