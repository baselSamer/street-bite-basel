import '../../../domain/entities/home/meal_entity.dart';

/// Firestore representation of a saved meal.
class FavoriteMealModel {
  final MealEntity meal;

  const FavoriteMealModel(this.meal);

  factory FavoriteMealModel.fromEntity(MealEntity meal) =>
      FavoriteMealModel(meal);

  factory FavoriteMealModel.fromJson(Map<String, dynamic> json) =>
      FavoriteMealModel(MealEntity.fromJson(json));

  Map<String, dynamic> toJson() => meal.toJson();

  MealEntity toEntity() => meal;
}
