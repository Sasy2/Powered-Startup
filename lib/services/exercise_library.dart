import '../models/exercise_models.dart';

/// Exercise library containing all available exercises
class ExerciseLibrary {
  static final List<Exercise> _exercises = [
    // RELAXATION EXERCISES
    Exercise(
      id: 'palming',
      name: 'Palming',
      description: 'Cover your eyes with warm palms and practice guided breathing',
      instructions: '1. Rub your hands together to warm them\n2. Cup your palms over your closed eyes\n3. Breathe deeply and slowly\n4. Focus on the darkness and relaxation\n5. Hold for 2-3 minutes',
      category: ExerciseCategory.relaxation,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 180,
      benefits: [
        'Reduces eye strain',
        'Relaxes eye muscles',
        'Improves circulation',
        'Reduces stress',
      ],
      iconName: 'visibility_off',
      hasAnimation: false,
      hasVoice: true,
      tags: ['breathing', 'relaxation', 'stress-relief'],
    ),

    Exercise(
      id: 'distance_shifting',
      name: 'Distance Shifting',
      description: 'Alternate looking at near vs far objects to exercise eye muscles',
      instructions: '1. Hold your thumb 6 inches from your face\n2. Focus on your thumb for 5 seconds\n3. Focus on a distant object for 5 seconds\n4. Repeat this cycle 10 times\n5. Blink frequently throughout',
      category: ExerciseCategory.relaxation,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      benefits: [
        'Strengthens eye muscles',
        'Improves focus flexibility',
        'Reduces eye fatigue',
        'Prevents accommodation spasm',
      ],
      iconName: 'zoom_out_map',
      hasAnimation: true,
      hasVoice: true,
      tags: ['focus', 'muscle-strength', 'flexibility'],
    ),

    Exercise(
      id: 'blinking_exercise',
      name: 'Blinking Exercise',
      description: 'Guided blinking session to refresh and lubricate your eyes',
      instructions: '1. Blink normally 10 times\n2. Close your eyes tightly for 3 seconds\n3. Open and blink rapidly 10 times\n4. Close eyes and rest for 30 seconds\n5. Repeat the cycle 3 times',
      category: ExerciseCategory.relaxation,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 90,
      benefits: [
        'Lubricates eyes naturally',
        'Reduces dry eye symptoms',
        'Refreshes vision',
        'Relaxes eye muscles',
      ],
      iconName: 'visibility',
      hasAnimation: false,
      hasVoice: true,
      tags: ['dry-eyes', 'lubrication', 'refresh'],
    ),

    // MIGRAINE RELIEF EXERCISES
    Exercise(
      id: 'smooth_pursuits',
      name: 'Smooth Pursuits',
      description: 'Follow a moving dot with your eyes to improve tracking',
      instructions: '1. Keep your head still\n2. Follow the moving dot with only your eyes\n3. Move smoothly without jerky movements\n4. Focus on the center of the dot\n5. Complete the full pattern',
      category: ExerciseCategory.migraineRelief,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      benefits: [
        'Improves eye tracking',
        'Reduces eye strain',
        'Helps with motion sickness',
        'Strengthens eye muscles',
      ],
      iconName: 'track_changes',
      hasAnimation: true,
      hasVoice: true,
      tags: ['tracking', 'motion', 'coordination'],
    ),

    Exercise(
      id: 'saccades',
      name: 'Saccades',
      description: 'Quick eye movements between two points to improve focus speed',
      instructions: '1. Keep your head still\n2. Look at the left dot when it appears\n3. Quickly shift to the right dot\n4. Continue alternating as they flash\n5. Focus on accuracy over speed',
      category: ExerciseCategory.migraineRelief,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 90,
      benefits: [
        'Improves focus speed',
        'Enhances peripheral vision',
        'Reduces eye fatigue',
        'Helps with reading efficiency',
      ],
      iconName: 'swap_horiz',
      hasAnimation: true,
      hasVoice: true,
      tags: ['speed', 'focus', 'peripheral-vision'],
    ),

    Exercise(
      id: 'figure_8_tracing',
      name: 'Figure-8 Tracing',
      description: 'Follow a figure-8 pattern with your eyes to improve coordination',
      instructions: '1. Keep your head still\n2. Follow the figure-8 path with your eyes\n3. Move smoothly in both directions\n4. Complete 5 full cycles clockwise\n5. Complete 5 full cycles counterclockwise',
      category: ExerciseCategory.migraineRelief,
      difficulty: ExerciseDifficulty.advanced,
      durationSeconds: 150,
      benefits: [
        'Improves eye coordination',
        'Strengthens eye muscles',
        'Enhances focus control',
        'Reduces eye strain',
      ],
      iconName: 'timeline',
      hasAnimation: true,
      hasVoice: true,
      tags: ['coordination', 'pattern', 'muscle-strength'],
    ),

    // FOCUS TRAINING EXERCISES
    Exercise(
      id: 'rotating_radial_lines',
      name: 'Rotating Radial Lines',
      description: 'Follow darkening radial lines to train focus and reduce astigmatism',
      instructions: '1. Focus on the center of the circle\n2. Follow the lines as they darken\n3. Keep your eyes moving smoothly\n4. Don\'t strain or force the movement\n5. Complete the full rotation',
      category: ExerciseCategory.focusTraining,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      benefits: [
        'Reduces astigmatism symptoms',
        'Improves focus accuracy',
        'Strengthens eye muscles',
        'Enhances visual clarity',
      ],
      iconName: 'radar',
      hasAnimation: true,
      hasVoice: true,
      tags: ['astigmatism', 'focus', 'clarity'],
    ),

    Exercise(
      id: 'focus_pyramid',
      name: 'Focus Pyramid',
      description: 'Read shrinking text to challenge and improve your focus ability',
      instructions: '1. Start with the largest text\n2. Read each line clearly\n3. Move to smaller text as you progress\n4. Don\'t strain - stop if text becomes unclear\n5. Complete all readable levels',
      category: ExerciseCategory.focusTraining,
      difficulty: ExerciseDifficulty.advanced,
      durationSeconds: 180,
      benefits: [
        'Improves near vision',
        'Enhances focus endurance',
        'Strengthens accommodation',
        'Reduces eye fatigue',
      ],
      iconName: 'format_size',
      hasAnimation: true,
      hasVoice: true,
      tags: ['near-vision', 'accommodation', 'endurance'],
    ),

    // SCREEN STRAIN RELIEF EXERCISES
    Exercise(
      id: 'twenty_twenty_twenty',
      name: '20-20-20 Rule',
      description: 'Look at something 20 feet away for 20 seconds every 20 minutes',
      instructions: '1. Set a timer for 20 minutes\n2. When it goes off, look at something 20 feet away\n3. Focus on that object for 20 seconds\n4. Blink 10 times slowly\n5. Return to your screen work',
      category: ExerciseCategory.screenStrainRelief,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 20,
      benefits: [
        'Prevents digital eye strain',
        'Reduces dry eyes',
        'Relaxes eye muscles',
        'Improves focus',
      ],
      iconName: 'schedule',
      hasAnimation: false,
      hasVoice: true,
      tags: ['prevention', 'routine', 'strain-relief'],
    ),

    Exercise(
      id: 'zooming_letters',
      name: 'Zooming Letters',
      description: 'Letters expand and contract to encourage eye accommodation',
      instructions: '1. Focus on the center letter\n2. Follow as it expands outward\n3. Follow as it contracts inward\n4. Keep your eyes relaxed\n5. Complete 10 expansion cycles',
      category: ExerciseCategory.screenStrainRelief,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 90,
      benefits: [
        'Improves accommodation',
        'Reduces eye strain',
        'Strengthens eye muscles',
        'Enhances focus flexibility',
      ],
      iconName: 'zoom_in',
      hasAnimation: true,
      hasVoice: true,
      tags: ['accommodation', 'flexibility', 'strain-relief'],
    ),
  ];

  /// Get all exercises
  static List<Exercise> getAllExercises() {
    return List.from(_exercises);
  }

  /// Get exercises by category
  static List<Exercise> getExercisesByCategory(ExerciseCategory category) {
    return _exercises.where((exercise) => exercise.category == category).toList();
  }

  /// Get exercises by difficulty
  static List<Exercise> getExercisesByDifficulty(ExerciseDifficulty difficulty) {
    return _exercises.where((exercise) => exercise.difficulty == difficulty).toList();
  }

  /// Get exercise by ID
  static Exercise? getExerciseById(String id) {
    try {
      return _exercises.firstWhere((exercise) => exercise.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get random exercises for daily suggestions
  static List<Exercise> getRandomExercises(int count, {List<ExerciseCategory>? preferredCategories}) {
    List<Exercise> availableExercises = _exercises;
    
    if (preferredCategories != null && preferredCategories.isNotEmpty) {
      availableExercises = _exercises.where((exercise) => 
        preferredCategories.contains(exercise.category)).toList();
    }
    
    availableExercises.shuffle();
    return availableExercises.take(count).toList();
  }

  /// Get daily exercise suggestions (3 exercises)
  static List<Exercise> getDailySuggestions({List<ExerciseCategory>? preferredCategories}) {
    // Try to get one from each category if possible
    final suggestions = <Exercise>[];
    final categories = preferredCategories ?? ExerciseCategory.values;
    
    for (final category in categories) {
      if (suggestions.length >= 3) break;
      
      final categoryExercises = getExercisesByCategory(category);
      if (categoryExercises.isNotEmpty) {
        categoryExercises.shuffle();
        suggestions.add(categoryExercises.first);
      }
    }
    
    // If we don't have 3 yet, fill with random exercises
    while (suggestions.length < 3) {
      final randomExercises = getRandomExercises(1, preferredCategories: categories);
      if (randomExercises.isNotEmpty) {
        final exercise = randomExercises.first;
        if (!suggestions.any((e) => e.id == exercise.id)) {
          suggestions.add(exercise);
        }
      } else {
        break; // No more exercises available
      }
    }
    
    return suggestions;
  }

  /// Search exercises by name or tags
  static List<Exercise> searchExercises(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _exercises.where((exercise) {
      return exercise.name.toLowerCase().contains(lowercaseQuery) ||
             exercise.description.toLowerCase().contains(lowercaseQuery) ||
             exercise.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  /// Get exercise categories with counts
  static Map<ExerciseCategory, int> getCategoryCounts() {
    final counts = <ExerciseCategory, int>{};
    for (final category in ExerciseCategory.values) {
      counts[category] = getExercisesByCategory(category).length;
    }
    return counts;
  }

  /// Get recommended exercises based on user progress
  static List<Exercise> getRecommendedExercises(
    Map<String, int> exerciseCounts, {
    int limit = 5,
  }) {
    // Find exercises that haven't been done much or at all
    final sortedExercises = _exercises.toList()
      ..sort((a, b) {
        final countA = exerciseCounts[a.id] ?? 0;
        final countB = exerciseCounts[b.id] ?? 0;
        return countA.compareTo(countB);
      });
    
    return sortedExercises.take(limit).toList();
  }

  /// Get exercise animation configuration
  static ExerciseAnimationConfig getAnimationConfig(String exerciseId) {
    switch (exerciseId) {
      case 'distance_shifting':
        return ExerciseAnimationConfig(
          type: 'dot',
          parameters: {
            'startSize': 20.0,
            'endSize': 5.0,
            'distance': 200.0,
            'speed': 2.0,
          },
          durationMs: 120000,
          loop: true,
          audioPrompt: 'Focus on the dot as it moves closer and farther away',
        );
      
      case 'smooth_pursuits':
        return ExerciseAnimationConfig(
          type: 'dot',
          parameters: {
            'path': 'circular',
            'radius': 100.0,
            'speed': 1.0,
            'color': 0xFF10B2D0,
          },
          durationMs: 120000,
          loop: true,
          audioPrompt: 'Follow the moving dot with your eyes smoothly',
        );
      
      case 'saccades':
        return ExerciseAnimationConfig(
          type: 'dot',
          parameters: {
            'positions': [
              {'x': -150.0, 'y': 0.0},
              {'x': 150.0, 'y': 0.0},
            ],
            'flashDuration': 2000,
            'pauseDuration': 1000,
            'color': 0xFF10B2D0,
          },
          durationMs: 90000,
          loop: true,
          audioPrompt: 'Quickly shift your gaze between the flashing dots',
        );
      
      case 'figure_8_tracing':
        return ExerciseAnimationConfig(
          type: 'figure8',
          parameters: {
            'width': 200.0,
            'height': 100.0,
            'speed': 0.8,
            'color': 0xFF10B2D0,
          },
          durationMs: 150000,
          loop: true,
          audioPrompt: 'Follow the figure-8 pattern with your eyes',
        );
      
      case 'rotating_radial_lines':
        return ExerciseAnimationConfig(
          type: 'radial',
          parameters: {
            'lineCount': 12,
            'radius': 120.0,
            'rotationSpeed': 0.5,
            'darkeningSpeed': 2.0,
            'color': 0xFF10B2D0,
          },
          durationMs: 120000,
          loop: true,
          audioPrompt: 'Follow the darkening lines as they rotate',
        );
      
      case 'focus_pyramid':
        return ExerciseAnimationConfig(
          type: 'text',
          parameters: {
            'texts': [
              'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z',
              'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z',
              'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z',
              'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z',
            ],
            'sizes': [32.0, 24.0, 18.0, 14.0],
            'transitionDuration': 3000,
            'readDuration': 5000,
          },
          durationMs: 180000,
          loop: false,
          audioPrompt: 'Read each line clearly as the text gets smaller',
        );
      
      case 'zooming_letters':
        return ExerciseAnimationConfig(
          type: 'text',
          parameters: {
            'text': 'A',
            'minSize': 20.0,
            'maxSize': 80.0,
            'zoomSpeed': 1.0,
            'color': 0xFF10B2D0,
          },
          durationMs: 90000,
          loop: true,
          audioPrompt: 'Focus on the letter as it expands and contracts',
        );
      
      default:
        return ExerciseAnimationConfig(
          type: 'dot',
          parameters: {'size': 20.0, 'color': 0xFF10B2D0},
          durationMs: 60000,
          loop: true,
        );
    }
  }
}
