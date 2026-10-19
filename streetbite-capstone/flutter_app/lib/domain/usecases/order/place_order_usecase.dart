import '../../entities/cart/cart_item.dart';
import '../../entities/order/order_entity.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/payment_processor.dart';

/// Checkout depends only on contracts. Another payment provider can be wired
/// through dependency injection without changing this use case.
class PlaceOrderUseCase {
  final PaymentProcessor _payment;
  final OrderRepository _orders;

  const PlaceOrderUseCase(this._payment, this._orders);

  Future<void> call({
    required String userId,
    required List<CartItem> items,
  }) async {
    if (items.isEmpty) throw StateError('Cannot place an empty order');
    final orderItems = items
        .map(
          (item) => OrderItemEntity(
            mealId: item.meal.id,
            name: item.meal.name,
            quantity: item.quantity,
            unitPriceEgp: item.meal.priceEgp,
          ),
        )
        .toList();
    final total = orderItems.fold<double>(
      0,
      (sum, item) => sum + item.unitPriceEgp * item.quantity,
    );
    await _payment.pay(total);
    await _orders.saveOrder(
      userId,
      OrderEntity(
        items: orderItems,
        totalPriceEgp: total,
        paymentMethod: _payment.methodName,
        status: 'placed',
      ),
    );
  }
}
