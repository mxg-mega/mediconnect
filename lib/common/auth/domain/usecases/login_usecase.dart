import 'package:mediconnect/common/auth/domain/entities/user_entity.dart';
import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<UserEntity> call(String email, String password) {
    return authRepository.login(email, password);
  }
}
