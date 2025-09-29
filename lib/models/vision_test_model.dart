class VisionTestModel {
  final String id;
  final String userId;
  final DateTime testDate;
  final VisionTestType type;
  final List<VisionTestQuestion> questions;
  final VisionTestResult result;
  final bool isCompleted;

  VisionTestModel({
    required this.id,
    required this.userId,
    required this.testDate,
    required this.type,
    required this.questions,
    required this.result,
    this.isCompleted = false,
  });

  factory VisionTestModel.fromMap(Map<String, dynamic> map) {
    return VisionTestModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      testDate: DateTime.parse(map['testDate'] ?? DateTime.now().toIso8601String()),
      type: VisionTestType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => VisionTestType.visualAcuity,
      ),
      questions: (map['questions'] as List<dynamic>?)
          ?.map((q) => VisionTestQuestion.fromMap(q))
          .toList() ?? [],
      result: VisionTestResult.fromMap(map['result'] ?? {}),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'testDate': testDate.toIso8601String(),
      'type': type.toString(),
      'questions': questions.map((q) => q.toMap()).toList(),
      'result': result.toMap(),
      'isCompleted': isCompleted,
    };
  }
}

enum VisionTestType {
  visualAcuity,
  colorVision,
  contrastSensitivity,
  astigmatism,
  comprehensive,
}

class VisionTestQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? userAnswer;
  final int difficulty; // 1-5 scale
  final QuestionType type;

  VisionTestQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.userAnswer,
    required this.difficulty,
    required this.type,
  });

  factory VisionTestQuestion.fromMap(Map<String, dynamic> map) {
    return VisionTestQuestion(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correctAnswer'] ?? '',
      userAnswer: map['userAnswer'],
      difficulty: map['difficulty'] ?? 1,
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => QuestionType.letter,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'userAnswer': userAnswer,
      'difficulty': difficulty,
      'type': type.toString(),
    };
  }
}

enum QuestionType {
  letter,
  number,
  symbol,
  color,
  direction,
}

class VisionTestResult {
  final double visualAcuity; // 20/20 format
  final String prescription; // e.g., "-1.25 -0.75 x 90"
  final String recommendation;
  final int score; // 0-100
  final List<String> issues; // detected issues
  final bool needsProfessionalCare;

  VisionTestResult({
    required this.visualAcuity,
    required this.prescription,
    required this.recommendation,
    required this.score,
    required this.issues,
    this.needsProfessionalCare = false,
  });

  factory VisionTestResult.fromMap(Map<String, dynamic> map) {
    return VisionTestResult(
      visualAcuity: (map['visualAcuity'] ?? 20.0).toDouble(),
      prescription: map['prescription'] ?? '',
      recommendation: map['recommendation'] ?? '',
      score: map['score'] ?? 0,
      issues: List<String>.from(map['issues'] ?? []),
      needsProfessionalCare: map['needsProfessionalCare'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'visualAcuity': visualAcuity,
      'prescription': prescription,
      'recommendation': recommendation,
      'score': score,
      'issues': issues,
      'needsProfessionalCare': needsProfessionalCare,
    };
  }
}

