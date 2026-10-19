import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/cart/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// Event-based cart BLoC; UI dispatches actions and observes immutable states.
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>((event, emit) {
      final index = state.items.indexWhere(
        (item) => item.meal.id == event.meal.id,
      );
      final updated = List<CartItem>.from(state.items);
      if (index >= 0) {
        updated[index] = updated[index].copyWith(
          quantity: updated[index].quantity + 1,
        );
      } else {
        updated.add(CartItem(meal: event.meal, quantity: 1));
      }
      emit(state.copyWith(items: updated));
    });

    on<CartItemRemoved>((event, emit) {
      final index = state.items.indexWhere(
        (item) => item.meal.id == event.mealId,
      );
      if (index < 0) return;
      final updated = List<CartItem>.from(state.items);
      if (updated[index].quantity > 1) {
        updated[index] = updated[index].copyWith(
          quantity: updated[index].quantity - 1,
        );
      } else {
        updated.removeAt(index);
      }
      emit(state.copyWith(items: updated));
    });

    on<CartCleared>((event, emit) => emit(const CartState()));
  }
}
