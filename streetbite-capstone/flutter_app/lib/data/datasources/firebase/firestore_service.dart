import 'package:cloud_firestore/cloud_firestore.dart';

/// Shared Firestore gateway. The private constructor enforces the Singleton
/// pattern so every feature uses the same configured Firestore client.
class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userCollection(
    String userId,
    String collection,
  ) => _firestore.collection('users').doc(userId).collection(collection);

  Stream<QuerySnapshot<Map<String, dynamic>>> watchFavorites(String userId) =>
      _userCollection(userId, 'favorites').snapshots();

  Future<void> setFavorite({
    required String userId,
    required String mealId,
    required Map<String, dynamic> meal,
    required bool isFavorite,
  }) async {
    final document = _userCollection(userId, 'favorites').doc(mealId);
    if (isFavorite) {
      await document.set(meal);
    } else {
      await document.delete();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchOrders(String userId) =>
      _userCollection(
        userId,
        'orders',
      ).orderBy('createdAt', descending: true).snapshots();

  Future<void> saveOrder({
    required String userId,
    required Map<String, dynamic> order,
  }) async {
    await _userCollection(
      userId,
      'orders',
    ).add({...order, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> updateProfilePhoto({
    required String userId,
    required String photoUrl,
  }) async {
    await _firestore.collection('users').doc(userId).set({
      'photoUrl': photoUrl,
    }, SetOptions(merge: true));
  }
}
