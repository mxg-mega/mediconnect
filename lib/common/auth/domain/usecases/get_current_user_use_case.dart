import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserModel?> call() async {
    return await repository.getCurrentUser();
  }
}