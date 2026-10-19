import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth/auth_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _auth;
  final ProfileRepository _profile;

  ProfileCubit({
    required AuthRepository auth,
    required ProfileRepository profile,
  }) : _auth = auth,
       _profile = profile,
       super(ProfileReady(auth.currentUser?.photoUrl));

  Future<void> chooseAndUploadPhoto() async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(ProfileFailure('signInToUpdatePhoto', state.photoUrl));
      return;
    }

    try {
      emit(ProfileLoading(state.photoUrl));
      final photoUrl = await _profile.chooseAndUploadPhoto(user.id);
      if (photoUrl == null) {
        emit(ProfileReady(state.photoUrl));
        return;
      }
      emit(ProfilePhotoUpdated(photoUrl));
    } catch (_) {
      emit(ProfileFailure('firebaseSaveError', state.photoUrl));
    }
  }
}
