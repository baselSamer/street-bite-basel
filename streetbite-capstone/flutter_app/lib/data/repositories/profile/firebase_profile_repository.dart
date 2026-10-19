import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/repositories/profile_repository.dart';
import '../../datasources/firebase/firestore_service.dart';
import '../../datasources/firebase/profile_photo_datasource.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseAuth _auth;
  final ImagePicker _picker;
  final ProfilePhotoDataSource _photos;
  final FirestoreService _firestore;

  const FirebaseProfileRepository(
    this._auth,
    this._picker,
    this._photos,
    this._firestore,
  );

  @override
  Future<String?> chooseAndUploadPhoto(String userId) async {
    final user = _auth.currentUser;
    if (user == null || user.uid != userId) {
      throw StateError('User session changed');
    }
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return null;
    final url = await _photos.upload(userId: userId, image: image);
    await user.updatePhotoURL(url);
    await _firestore.updateProfilePhoto(userId: userId, photoUrl: url);
    return url;
  }
}
