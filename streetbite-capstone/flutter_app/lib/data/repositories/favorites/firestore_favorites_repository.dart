import '../../../domain/entities/home/meal_entity.dart';
import '../../../domain/repositories/favorites_repository.dart';
import '../../datasources/firebase/firestore_service.dart';
import '../../models/favorites/favorite_meal_model.dart';

class FirestoreFavoritesRepository implements FavoritesRepository {
  final FirestoreService _firestore;

  const FirestoreFavoritesRepository(this._firestore);

  @override
  Stream<List<MealEntity>> watchFavorites(String userId) => _firestore
      .watchFavorites(userId)
      .map(
        (snapshot) => snapshot.docs
            .map(
              (document) =>
                  FavoriteMealModel.fromJson(document.data()).toEntity(),
            )
            .toList(),
      );

  @override
  Future<void> setFavorite(String userId, MealEntity meal, bool isFavorite) =>
      _firestore.setFavorite(
        userId: userId,
        mealId: meal.id,
        meal: FavoriteMealModel.fromEntity(meal).toJson(),
        isFavorite: isFavorite,
      );
}
