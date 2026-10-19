abstract class ProfileState {
  final String? photoUrl;

  const ProfileState(this.photoUrl);
}

class ProfileReady extends ProfileState {
  const ProfileReady(super.photoUrl);
}

class ProfileLoading extends ProfileState {
  const ProfileLoading(super.photoUrl);
}

class ProfilePhotoUpdated extends ProfileState {
  const ProfilePhotoUpdated(super.photoUrl);
}

class ProfileFailure extends ProfileState {
  final String messageKey;

  const ProfileFailure(this.messageKey, super.photoUrl);
}
