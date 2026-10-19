import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/auth/user_entity.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  const FirebaseAuthDataSource(this._auth);

  UserEntity? get currentUser {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return null;
    return UserEntityBuilder()
        .id(user.uid)
        .email(user.email!)
        .displayName(user.displayName)
        .photoUrl(user.photoURL)
        .build();
  }

  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return UserEntityBuilder()
        .id(user.uid)
        .email(user.email!)
        .displayName(user.displayName)
        .photoUrl(user.photoURL)
        .build();
  }

  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(name);
    return UserEntityBuilder()
        .id(user.uid)
        .email(user.email!)
        .displayName(name)
        .photoUrl(user.photoURL)
        .build();
  }

  Future<void> logout() => _auth.signOut();
}
