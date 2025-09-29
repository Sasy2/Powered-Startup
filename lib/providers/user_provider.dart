import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class UserProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCurrentUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final firebaseUser = await _firebaseService.getCurrentUser();
      if (firebaseUser != null) {
        _currentUser = await _firebaseService.getUserProfile(firebaseUser.uid);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _firebaseService.signInWithEmail(email, password);
      _currentUser = await _firebaseService.getUserProfile(userCredential.user!.uid);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _firebaseService.createUserWithEmail(email, password);
      
      // Create user profile
      final newUser = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        preferences: UserPreferences(),
        stats: UserStats(
          lastVisionTest: DateTime.now(),
          lastExercise: DateTime.now(),
        ),
      );
      
      await _firebaseService.createUserProfile(newUser);
      _currentUser = newUser;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firebaseService.signOut();
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firebaseService.updateUserProfile(updatedUser);
      _currentUser = updatedUser;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

