import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';

class VerifyEmailOtpUseCase {
  final AuthRepository repository;

  VerifyEmailOtpUseCase(this.repository);

  Future<void> call(String code) async {
    return await repository.verifyEmailOtp(code);
  }
}
