import '../../../domain/entities/home/meal_entity.dart';

sealed class CartEvent {
  const CartEvent();
}

class CartItemAdded extends CartEvent {
  final MealEntity meal;
  const CartItemAdded(this.meal);
}

class CartItemRemoved extends CartEvent {
  final String mealId;
  const CartItemRemoved(this.mealId);
}

class CartCleared extends CartEvent {
  const CartCleared();
}
