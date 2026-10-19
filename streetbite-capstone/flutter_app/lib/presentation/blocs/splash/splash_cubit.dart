import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth/auth_repository.dart';

import './splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository _authRepository;
  SplashCubit(this._authRepository) : super(SplashInitial());

  Future<void> checkAuthState() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(SplashAuthenticated());
    } else {
      emit(SplashUnauthenticated());
    }
  }
}
