import 'package:street_bite_test/domain/entities/home/meal_entity.dart';

/// Shared test fixtures for feature-specific automation scenarios.
abstract class BaseTest {
  static const meal = MealEntity(
    id: 'meal-1',
    name: 'Test meal',
    category: 'Test category',
    area: 'Test area',
    thumbnailUrl: '',
    priceEgp: 75,
  );
}
