import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';

class SendEmailVerificationUseCase {
  final AuthRepository repository;

  SendEmailVerificationUseCase(this.repository);

  Future<void> call(String email) async {
    return await repository.sendEmailVerification(email);
  }
}
