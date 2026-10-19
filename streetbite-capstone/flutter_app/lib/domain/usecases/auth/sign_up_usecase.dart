import '../../entities/auth/user_entity.dart';
import '../../repositories/auth/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  const SignUpUseCase(this._repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) => _repository.signUp(name: name, email: email, password: password);
}
