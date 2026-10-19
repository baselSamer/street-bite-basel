import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/auth/auth_failure.dart';

import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/sign_up_usecase.dart';
import './auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _signUpUseCase = signUpUseCase,
       _logoutUseCase = logoutUseCase,
       super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await _loginUseCase(email: email, password: password);
      emit(AuthAuthenticated(user));
    } on AuthFailure catch (e) {
      emit(AuthError(e.messageKey));
    } catch (_) {
      emit(AuthError('errorUnknown'));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _signUpUseCase(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } on AuthFailure catch (e) {
      emit(AuthError(e.messageKey));
    } catch (_) {
      emit(AuthError('errorUnknown'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _logoutUseCase();
      emit(AuthLoggedOut());
    } catch (_) {
      emit(AuthError('errorUnknown'));
    }
  }
}
