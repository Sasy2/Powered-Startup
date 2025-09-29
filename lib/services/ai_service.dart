import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_model.dart';
import '../models/vision_test_model.dart';
import '../models/user_model.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  // OpenRouter API configuration
  static const String _openRouterApiKey = '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';
  static const String _openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  
  // fal.ai configuration for voice
  static const String _falApiKey = 'YOUR_FAL_API_KEY';
  static const String _falBaseUrl = 'https://fal.run/fal-ai';

  // Chat with AI EyeDoctor
  Future<String> chatWithEyeDoctor(String message, String userId, {List<ChatMessage>? history}) async {
    try {
      final messages = <Map<String, String>>[];
      
      // System prompt for EyeDoctor
      messages.add({
        'role': 'system',
        'content': '''You are EyeDoctor, an AI-powered eye care assistant specializing in vision health for African communities. 
        
        Your expertise includes:
        - Vision testing and eye health assessment
        - Eye exercises and preventive care
        - Common eye conditions and symptoms
        - Screen time management and digital eye strain
        - When to seek professional medical attention
        
        Guidelines:
        - Provide helpful, accurate information about eye health
        - Always recommend professional consultation for serious symptoms
        - Be encouraging and supportive
        - Use simple, clear language
        - Focus on preventive care and healthy habits
        - Consider cultural context and accessibility challenges
        
        Remember: You are not a replacement for professional medical care, but a helpful guide for eye health awareness and basic care.'''
      });

      // Add conversation history
      if (history != null && history.isNotEmpty) {
        final recentHistory = history.take(10).toList().reversed;
        for (final msg in recentHistory) {
          messages.add({
            'role': msg.isFromUser ? 'user' : 'assistant',
            'content': msg.content,
          });
        }
      }

      // Add current message
      messages.add({
        'role': 'user',
        'content': message,
      });

      final response = await http.post(
        Uri.parse('$_openRouterBaseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_openRouterApiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://eyecon-app.com',
          'X-Title': 'EyeCon App',
        },
        body: jsonEncode({
          'model': 'meta-llama/llama-3.1-8b-instruct:free',
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      return 'I apologize, but I\'m having trouble connecting right now. Please try again later or consult with a healthcare professional for immediate concerns.';
    }
  }

  // Generate personalized recommendations
  Future<List<AIRecommendation>> generateRecommendations(UserModel user, UserStats stats) async {
    try {
      final prompt = '''Based on the following user profile and statistics, generate 3-5 personalized eye health recommendations:

User Profile:
- Name: ${user.name}
- Total Vision Tests: ${stats.totalVisionTests}
- Total Exercises Completed: ${stats.totalExercisesCompleted}
- Current Streak: ${stats.currentStreak} days
- Average Screen Time: ${stats.averageScreenTime} hours/day
- Last Vision Test: ${stats.lastVisionTest}
- Last Exercise: ${stats.lastExercise}

Generate recommendations in JSON format with the following structure:
[
  {
    "title": "Recommendation Title",
    "description": "Detailed description of the recommendation",
    "type": "exercise|test|rest|consultation|lifestyle|medication",
    "priority": 1-5,
    "metadata": {
      "exerciseId": "optional_exercise_id",
      "duration": "optional_duration_in_minutes",
      "frequency": "optional_frequency"
    }
  }
]

Focus on:
1. Improving current streak and exercise consistency
2. Managing screen time effectively
3. Regular vision testing
4. Preventive eye care habits
5. When to seek professional help''';

      final response = await http.post(
        Uri.parse('$_openRouterBaseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_openRouterApiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://eyecon-app.com',
          'X-Title': 'EyeCon App',
        },
        body: jsonEncode({
          'model': 'meta-llama/llama-3.1-8b-instruct:free',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 1000,
          'temperature': 0.5,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Extract JSON from response
        final jsonMatch = RegExp(r'\[.*\]', multiLine: true, dotAll: true).firstMatch(content);
        if (jsonMatch != null) {
          final recommendationsJson = jsonDecode(jsonMatch.group(0)!);
          return (recommendationsJson as List).map((rec) => AIRecommendation(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: user.id,
            title: rec['title'],
            description: rec['description'],
            type: RecommendationType.values.firstWhere(
              (e) => e.toString().split('.').last == rec['type'],
              orElse: () => RecommendationType.exercise,
            ),
            priority: rec['priority'] ?? 1,
            createdAt: DateTime.now(),
            metadata: rec['metadata'],
          )).toList();
        }
      }
    } catch (e) {
      // Error generating recommendations: $e
    }

    // Fallback recommendations
    return _getFallbackRecommendations(user, stats);
  }

  // Analyze vision test results
  Future<VisionTestResult> analyzeVisionTest(List<VisionTestQuestion> questions) async {
    try {
      final correctAnswers = questions.where((q) => q.userAnswer == q.correctAnswer).length;
      final totalQuestions = questions.length;
      final accuracy = correctAnswers / totalQuestions;

      // Simple analysis based on accuracy
      double visualAcuity = 20.0;
      String prescription = '';
      String recommendation = '';
      List<String> issues = [];
      bool needsProfessionalCare = false;

      if (accuracy >= 0.9) {
        visualAcuity = 20.0;
        recommendation = 'Excellent vision! Continue with regular eye exercises and annual checkups.';
      } else if (accuracy >= 0.7) {
        visualAcuity = 20.0;
        recommendation = 'Good vision with minor issues. Consider more frequent eye exercises.';
      } else if (accuracy >= 0.5) {
        visualAcuity = 20.0;
        prescription = 'Mild prescription may be needed';
        recommendation = 'Consider scheduling an eye exam with a professional.';
        issues.add('Mild vision impairment detected');
      } else {
        visualAcuity = 20.0;
        prescription = 'Professional evaluation recommended';
        recommendation = 'Please consult with an eye care professional for a comprehensive examination.';
        issues.add('Significant vision issues detected');
        needsProfessionalCare = true;
      }

      return VisionTestResult(
        visualAcuity: visualAcuity,
        prescription: prescription,
        recommendation: recommendation,
        score: (accuracy * 100).round(),
        issues: issues,
        needsProfessionalCare: needsProfessionalCare,
      );
    } catch (e) {
      return VisionTestResult(
        visualAcuity: 20.0,
        prescription: 'Unable to analyze',
        recommendation: 'Please retake the test or consult a professional.',
        score: 0,
        issues: ['Analysis error'],
        needsProfessionalCare: true,
      );
    }
  }

  // Convert text to speech using fal.ai
  Future<String> textToSpeech(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$_falBaseUrl/tts'),
        headers: {
          'Authorization': 'Key $_falApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'text': text,
          'voice': 'en-US-Standard-A', // Female voice
          'speed': 1.0,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['audio_url'] ?? '';
      }
    } catch (e) {
      // Error converting text to speech: $e
    }
    return '';
  }

  // Convert speech to text using fal.ai
  Future<String> speechToText(String audioUrl) async {
    try {
      final response = await http.post(
        Uri.parse('$_falBaseUrl/whisper'),
        headers: {
          'Authorization': 'Key $_falApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'audio_url': audioUrl,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text'] ?? '';
      }
    } catch (e) {
      // Error converting speech to text: $e
    }
    return '';
  }

  // Fallback recommendations when AI is unavailable
  List<AIRecommendation> _getFallbackRecommendations(UserModel user, UserStats stats) {
    final recommendations = <AIRecommendation>[];

    if (stats.currentStreak < 3) {
      recommendations.add(AIRecommendation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.id,
        title: 'Build Your Exercise Streak',
        description: 'Try to complete at least one eye exercise daily to build a healthy habit.',
        type: RecommendationType.exercise,
        priority: 4,
        createdAt: DateTime.now(),
      ));
    }

    if (stats.averageScreenTime > 6) {
      recommendations.add(AIRecommendation(
        id: '${DateTime.now().millisecondsSinceEpoch}1',
        userId: user.id,
        title: 'Reduce Screen Time',
        description: 'Your screen time is high. Try the 20-20-20 rule: every 20 minutes, look at something 20 feet away for 20 seconds.',
        type: RecommendationType.lifestyle,
        priority: 3,
        createdAt: DateTime.now(),
      ));
    }

    if (stats.totalVisionTests == 0 || DateTime.now().difference(stats.lastVisionTest).inDays > 30) {
      recommendations.add(AIRecommendation(
        id: '${DateTime.now().millisecondsSinceEpoch}2',
        userId: user.id,
        title: 'Take a Vision Test',
        description: 'Regular vision testing helps track your eye health. Take our quick test to check your current vision.',
        type: RecommendationType.test,
        priority: 5,
        createdAt: DateTime.now(),
      ));
    }

    return recommendations;
  }
}
