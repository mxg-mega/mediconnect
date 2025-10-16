import 'package:mediconnect/common/auth/domain/entities/user_entity.dart';
import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository authRepository;

  SignupUseCase(this.authRepository);

  Future<UserEntity> call(String name, String email, String password) {
    return authRepository.signup(name, email, password);
  }
}
