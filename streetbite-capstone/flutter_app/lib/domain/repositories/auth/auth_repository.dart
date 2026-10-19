import '../../entities/auth/user_entity.dart';

abstract class AuthRepository {
  UserEntity? get currentUser;
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
}
