import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';

class VerifyEmailOtpUseCase {
  final AuthRepository repository;

  VerifyEmailOtpUseCase(this.repository);

  Future<String?> call(String email, String code, {String intent = 'signup'}) async {
    return await repository.verifyEmailOtp(email, code, intent: intent);
  }
}
