import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/core/errors/exceptions.dart';

class FirebaseStorageLayer implements StorageLayer {
  final FirebaseAuth _firebaseAuth;

  FirebaseStorageLayer({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    switch (endpoint) {
      case '/auth/signup':
        try {
          final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: data['email'] as String,
            password: data['password'] as String,
          );

          // Update display name
          await userCredential.user?.updateDisplayName(
            '${data['firstName']} ${data['lastName']}',
          );

          return {
            'user_id': userCredential.user?.uid,
            'email': userCredential.user?.email,
            'display_name': userCredential.user?.displayName,
            'phone_number': data['phoneNumber'],
          };
        } on FirebaseAuthException catch (e) {
          throw AuthException(_getAuthErrorMessage(e));
        }

      case '/auth/login':
        try {
          final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: data['email'] as String,
            password: data['password'] as String,
          );

          return {
            'user_id': userCredential.user?.uid,
            'email': userCredential.user?.email,
            'display_name': userCredential.user?.displayName,
          };
        } on FirebaseAuthException catch (e) {
          throw AuthException(_getAuthErrorMessage(e));
        }

      default:
        throw ServerException('Unsupported endpoint: $endpoint');
    }
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    if (endpoint == '/auth/current-user') {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return {
          'user_id': user.uid,
          'email': user.email,
          'display_name': user.displayName,
        };
      } else {
        throw AuthException('No user currently signed in');
      }
    }
    throw ServerException('Unsupported endpoint: $endpoint');
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    // Firebase auth doesn't typically use PUT for updates
    throw ServerException('PUT not supported for Firebase operations');
  }

  @override
  Future<void> delete(String endpoint) async {
    if (endpoint == '/auth/signout') {
      await _firebaseAuth.signOut();
    } else {
      throw ServerException('Unsupported endpoint: $endpoint');
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak';
      case 'email-already-in-use':
        return 'The account already exists for that email';
      case 'user-not-found':
        return 'No user found for that email';
      case 'wrong-password':
        return 'Wrong password provided for that user';
      case 'invalid-email':
        return 'The email address is badly formatted';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'too-many-requests':
        return 'Too many requests. Try again later';
      default:
        return e.message ?? 'Authentication error occurred';
    }
  }
}
