import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call(String email, String resetToken, String newPassword) async {
    return await repository.resetPassword(email, resetToken, newPassword);
  }
}
