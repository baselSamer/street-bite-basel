import '../../../domain/entities/cart/cart_item.dart';

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  /// Total number of individual units across all cart items.
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Derived total keeps pricing reactive whenever an item quantity changes.
  double get totalPriceEgp =>
      items.fold(0, (sum, item) => sum + item.meal.priceEgp * item.quantity);

  CartState copyWith({List<CartItem>? items}) =>
      CartState(items: items ?? this.items);
}
