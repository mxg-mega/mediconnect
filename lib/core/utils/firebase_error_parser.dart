import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseErrorParser {
  static String parseError(dynamic error) {
    if (error is FirebaseAuthException) {
      return _parseAuthException(error);
    } else if (error is FirebaseFunctionsException) {
      return _parseFunctionsException(error);
    } else if (error is TimeoutException) {
      return 'Connection timed out. Please check your internet connection and try again.';
    } else {
      // Fallback for generic errors, stripping out "Exception:" prefix if it exists
      final message = error.toString();
      if (message.startsWith('Exception: ')) {
        return message.replaceFirst('Exception: ', '');
      }
      return 'An unexpected error occurred. Please try again.';
    }
  }

  static String _parseAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No account found for this email address.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }

  static String _parseFunctionsException(FirebaseFunctionsException error) {
    switch (error.code) {
      case 'unauthenticated':
        return 'You must be logged in to perform this action.';
      case 'not-found':
        return error.message ?? 'The requested resource was not found.';
      case 'invalid-argument':
        return error.message ?? 'Invalid input provided.';
      case 'failed-precondition':
        return error.message ?? 'Action failed due to current state.';
      case 'permission-denied':
        return error.message ?? 'You do not have permission to do this.';
      case 'internal':
        return 'An internal server error occurred. Please try again later.';
      case 'deadline-exceeded':
        return 'The server took too long to respond. Please try again.';
      default:
        return error.message ?? 'An error occurred while communicating with the server.';
    }
  }
}
