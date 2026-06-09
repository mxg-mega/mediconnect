import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mediconnect/common/auth/data/datasources/auth_data_source.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  @override
  final StorageLayer storageLayer;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    required this.storageLayer,
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    print('FirebaseAuthDataSource: Starting signUp for $email');
    try {
      // 1. Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      print('FirebaseAuthDataSource: User created in Auth. UID: $uid');

      // 2. Create profile in Firestore
      final newUser = UserModel(
        id: uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        userType: UserType.unknown, // Default until setup finalization
        verificationStatus: VerificationStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(newUser.toJson());
      print('FirebaseAuthDataSource: User profile saved to Firestore.');

      // Cache user locally
      try {
        await storageLayer.put('current_user', newUser.toJson());
      } catch (e) {
        print('FirebaseAuthDataSource: Error caching user locally: $e');
      }

      return newUser;
    } catch (e) {
      print('FirebaseAuthDataSource: signUp Exception: $e');
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    print('FirebaseAuthDataSource: Starting signIn for $email');
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 15));

      final uid = userCredential.user!.uid;
      print('FirebaseAuthDataSource: Logged into Auth. UID: $uid. Fetching profile...');
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        print('FirebaseAuthDataSource: Profile not found in Firestore!');
        throw Exception('User profile not found in Firestore');
      }

      print('FirebaseAuthDataSource: Profile fetched successfully.');
      final userModel = UserModel.fromJson(doc.data()!);
      
      // Cache user locally
      try {
        await storageLayer.put('current_user', userModel.toJson());
      } catch (e) {
        print('FirebaseAuthDataSource: Error caching user locally: $e');
      }
      
      return userModel;
    } catch (e) {
      print('FirebaseAuthDataSource: signIn Exception: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    try {
      await storageLayer.delete('current_user');
      await storageLayer.delete('current_business');
      await storageLayer.delete('current_memberships');
    } catch (_) {}
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      await _firestore.collection('users').doc(user.id).update(updatedUser.toJson());
      
      try {
        await storageLayer.put('current_user', updatedUser.toJson());
      } catch (_) {}

      return updatedUser;
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }
  
  @override
  Future<void> sendEmailVerification(String email, {String intent = 'signup'}) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('generateOTP');
      await callable.call({'email': email, 'intent': intent});
    } catch (e) {
      throw Exception('Failed to send verification email: ${e.toString()}');
    }
  }

  @override
  Future<String?> verifyEmailOtp(String email, String code, {String intent = 'signup'}) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('verifyOTP');
      final result = await callable.call({'email': email, 'code': code, 'intent': intent});
      
      if (intent == 'password_reset') {
        return result.data['resetToken'] as String?;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email, String resetToken, String newPassword) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('resetPassword');
      await callable.call({
        'email': email,
        'resetToken': resetToken,
        'newPassword': newPassword,
      });
    } catch (e) {
      throw Exception('Failed to reset password: ${e.toString()}');
    }
  }

  // social login logic would be added here...
}
