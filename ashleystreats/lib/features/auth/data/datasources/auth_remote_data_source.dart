import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        return _userFromFirebase(user);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(displayName);
        // Optionally update phone number if needed
        return _userFromFirebase(user);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return _userFromFirebase(user);
    }
    return null;
  }

  UserModel _userFromFirebase(User user) {
    return UserModel(
      userId: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      phoneNumber: user.phoneNumber ?? '',
      role: 'customer', // Default, update as needed
      addresses: [],
      preferences: {},
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      lastActive: user.metadata.lastSignInTime ?? DateTime.now(),
    );
  }
}
