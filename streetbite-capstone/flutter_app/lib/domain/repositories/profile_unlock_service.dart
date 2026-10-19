enum ProfileUnlockResult { granted, unavailable, denied }

abstract interface class ProfileUnlockService {
  Future<ProfileUnlockResult> unlock(String reason);
}
