import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/vision_test_model.dart';
import '../models/exercise_model.dart';
import '../models/chat_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;

  Future<void> initialize() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }

  // Authentication
  Future<User?> getCurrentUser() async => _auth.currentUser;
  
  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);
  
  Future<UserCredential> createUserWithEmail(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);
  
  Future<void> signOut() => _auth.signOut();

  // User Management
  Future<void> createUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  // Vision Tests
  Future<void> saveVisionTest(VisionTestModel test) async {
    await _firestore.collection('vision_tests').doc(test.id).set(test.toMap());
  }

  Future<List<VisionTestModel>> getUserVisionTests(String userId) async {
    final query = await _firestore
        .collection('vision_tests')
        .where('userId', isEqualTo: userId)
        .orderBy('testDate', descending: true)
        .get();
    
    return query.docs.map((doc) => VisionTestModel.fromMap(doc.data())).toList();
  }

  Future<VisionTestModel?> getVisionTest(String testId) async {
    final doc = await _firestore.collection('vision_tests').doc(testId).get();
    if (doc.exists) {
      return VisionTestModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Exercises
  Future<List<ExerciseModel>> getExercises() async {
    final query = await _firestore.collection('exercises').get();
    return query.docs.map((doc) => ExerciseModel.fromMap(doc.data())).toList();
  }

  Future<ExerciseModel?> getExercise(String exerciseId) async {
    final doc = await _firestore.collection('exercises').doc(exerciseId).get();
    if (doc.exists) {
      return ExerciseModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> saveExerciseSession(ExerciseSession session) async {
    await _firestore.collection('exercise_sessions').doc(session.id).set(session.toMap());
  }

  Future<List<ExerciseSession>> getUserExerciseSessions(String userId) async {
    final query = await _firestore
        .collection('exercise_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .get();
    
    return query.docs.map((doc) => ExerciseSession.fromMap(doc.data())).toList();
  }

  Future<void> saveDailyPlan(DailyPlan plan) async {
    await _firestore.collection('daily_plans').doc(plan.id).set(plan.toMap());
  }

  Future<DailyPlan?> getDailyPlan(String userId, DateTime date) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final doc = await _firestore
        .collection('daily_plans')
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: dateStr)
        .get();
    
    if (doc.docs.isNotEmpty) {
      return DailyPlan.fromMap(doc.docs.first.data());
    }
    return null;
  }

  // Chat
  Future<void> saveChatMessage(ChatMessage message) async {
    await _firestore.collection('chat_messages').doc(message.id).set(message.toMap());
  }

  Future<List<ChatMessage>> getChatMessages(String userId, {int limit = 50}) async {
    final query = await _firestore
        .collection('chat_messages')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    
    return query.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList();
  }

  Future<void> saveChatSession(ChatSession session) async {
    await _firestore.collection('chat_sessions').doc(session.id).set(session.toMap());
  }

  Future<List<ChatSession>> getUserChatSessions(String userId) async {
    final query = await _firestore
        .collection('chat_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .get();
    
    return query.docs.map((doc) => ChatSession.fromMap(doc.data())).toList();
  }

  // AI Recommendations
  Future<void> saveAIRecommendation(AIRecommendation recommendation) async {
    await _firestore.collection('ai_recommendations').doc(recommendation.id).set(recommendation.toMap());
  }

  Future<List<AIRecommendation>> getUserRecommendations(String userId) async {
    final query = await _firestore
        .collection('ai_recommendations')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    
    return query.docs.map((doc) => AIRecommendation.fromMap(doc.data())).toList();
  }

  // Real-time listeners
  Stream<List<ChatMessage>> getChatMessagesStream(String userId) {
    return _firestore
        .collection('chat_messages')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList());
  }

  Stream<DailyPlan?> getDailyPlanStream(String userId, DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _firestore
        .collection('daily_plans')
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: dateStr)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return DailyPlan.fromMap(snapshot.docs.first.data());
          }
          return null;
        });
  }
}
