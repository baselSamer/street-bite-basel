import '../entities/home/meal_entity.dart';

abstract interface class FavoritesRepository {
  Stream<List<MealEntity>> watchFavorites(String userId);
  Future<void> setFavorite(String userId, MealEntity meal, bool isFavorite);
}
