import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// Uploads user-selected profile photos to a per-user Storage path.
class ProfilePhotoDataSource {
  final FirebaseStorage _storage;

  const ProfilePhotoDataSource(this._storage);

  Future<String> upload({required String userId, required XFile image}) async {
    final reference = _storage.ref().child(
      'profile_photos/$userId/profile-photo',
    );
    final contentType = image.mimeType ?? 'image/jpeg';
    await reference.putData(
      await image.readAsBytes(),
      SettableMetadata(contentType: contentType),
    );
    return reference.getDownloadURL();
  }
}
