// import 'package:mediconnect/common/auth/data/datasources/auth_data_source.dart';
// import 'package:mediconnect/common/auth/data/models/user_model.dart';

// class LocalAuthDataSource implements AuthDataSource {
//   @override
//   Future<UserModel> signUp({
//     required String email,
//     required String password,
//     required String firstName,
//     required String lastName,
//     required String phoneNumber,
//   }) async {
//     await Future.delayed(const Duration(seconds: 1));
//     return UserModel(
//       id: '123',
//       email: email,
//       firstName: firstName,
//       lastName: lastName,
//       phoneNumber: phoneNumber,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//   }

//   @override
//   Future<UserModel> signIn({
//     required String email,
//     required String password,
//   }) async {
//     await Future.delayed(const Duration(seconds: 1));
//     if (email == 'test@example.com' && password == 'password') {
//       return UserModel(
//         id: '123',
//         email: 'test@example.com',
//         firstName: 'Test',
//         lastName: 'User',
//         phoneNumber: '1234567890',
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );
//     } else {
//       throw Exception('Invalid credentials');
//     }
//   }

//   @override
//   Future<void> signOut() async {
//     await Future.delayed(const Duration(seconds: 1));
//   }

//   @override
//   Future<UserModel?> getCurrentUser() async {
//     await Future.delayed(const Duration(seconds: 1));
//     return null;
//   }
// }
