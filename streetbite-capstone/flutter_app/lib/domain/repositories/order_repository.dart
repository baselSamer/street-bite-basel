import '../entities/order/order_entity.dart';

abstract interface class OrderRepository {
  Future<void> saveOrder(String userId, OrderEntity order);
  Stream<List<OrderEntity>> watchOrders(String userId);
}
