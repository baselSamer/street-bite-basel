abstract interface class ProfileRepository {
  /// Returns null when the image picker is cancelled.
  Future<String?> chooseAndUploadPhoto(String userId);
}
