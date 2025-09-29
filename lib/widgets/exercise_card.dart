import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  final PlannedExercise? plannedExercise;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.plannedExercise,
    this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isPlanned = plannedExercise != null;
    final isCompleted = plannedExercise?.isCompleted ?? false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: isCompleted 
              ? Border.all(color: const Color(0xFF4ECDC4), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTypeColor(exercise.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(exercise.type),
                    color: _getTypeColor(exercise.type),
                    size: 24,
                  ),
                ),
                const Spacer(),
                if (isPlanned)
                  GestureDetector(
                    onTap: onComplete,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? const Color(0xFF4ECDC4) 
                            : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.play_arrow,
                        color: isCompleted ? Colors.white : const Color(0xFF618389),
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111718),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              exercise.description,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF618389),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: const Color(0xFF618389),
                ),
                const SizedBox(width: 5),
                Text(
                  '${exercise.duration} min',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF618389),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(exercise.difficulty).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getDifficultyText(exercise.difficulty),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getDifficultyColor(exercise.difficulty),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(ExerciseType type) {
    switch (type) {
      case ExerciseType.focus:
        return const Color(0xFF10B2D0);
      case ExerciseType.relaxation:
        return const Color(0xFF4ECDC4);
      case ExerciseType.strength:
        return const Color(0xFFFF6B6B);
      case ExerciseType.flexibility:
        return const Color(0xFF96CEB4);
      case ExerciseType.coordination:
        return const Color(0xFFFFD93D);
      case ExerciseType.breathing:
        return const Color(0xFF6C5CE7);
    }
  }

  IconData _getTypeIcon(ExerciseType type) {
    switch (type) {
      case ExerciseType.focus:
        return Icons.center_focus_strong;
      case ExerciseType.relaxation:
        return Icons.spa;
      case ExerciseType.strength:
        return Icons.fitness_center;
      case ExerciseType.flexibility:
        return Icons.accessibility;
      case ExerciseType.coordination:
        return Icons.touch_app;
      case ExerciseType.breathing:
        return Icons.air;
    }
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return const Color(0xFF4ECDC4);
      case DifficultyLevel.intermediate:
        return const Color(0xFFFFD93D);
      case DifficultyLevel.advanced:
        return const Color(0xFFFF6B6B);
    }
  }

  String _getDifficultyText(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Easy';
      case DifficultyLevel.intermediate:
        return 'Medium';
      case DifficultyLevel.advanced:
        return 'Hard';
    }
  }
}

