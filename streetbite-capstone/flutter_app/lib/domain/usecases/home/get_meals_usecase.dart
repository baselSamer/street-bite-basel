import '../../entities/home/meal_entity.dart';
import '../../repositories/home/meal_repository.dart';

class GetMealsUseCase {
  final MealRepository _repository;
  const GetMealsUseCase(this._repository);

  Future<List<MealEntity>> call() => _repository.getMeals();

  Future<MealEntity?> getDetails(String mealId) =>
      _repository.getMealDetails(mealId);
}
