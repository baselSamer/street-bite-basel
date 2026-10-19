import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/auth/user_entity.dart';
import '../../../domain/entities/auth/auth_failure.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../datasources/auth/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;
  const AuthRepositoryImpl(this._dataSource);

  @override
  UserEntity? get currentUser => _dataSource.currentUser;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource.login(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error.code));
    }
  }

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error.code));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dataSource.logout();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error.code));
    }
  }

  String _messageFor(String code) => switch (code) {
    'user-not-found' => 'errorUserNotFound',
    'wrong-password' => 'errorWrongPassword',
    'email-already-in-use' => 'errorEmailInUse',
    'weak-password' => 'errorWeakPassword',
    'network-request-failed' => 'errorNetworkRequest',
    'too-many-requests' => 'errorTooManyRequests',
    'invalid-credential' => 'errorInvalidCredential',
    _ => 'errorUnknown',
  };
}
