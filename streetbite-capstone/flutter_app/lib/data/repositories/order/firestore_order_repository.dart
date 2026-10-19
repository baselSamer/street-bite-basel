import '../../../domain/entities/order/order_entity.dart';
import '../../../domain/repositories/order_repository.dart';
import '../../datasources/firebase/firestore_service.dart';
import '../../models/order/order_model.dart';

class FirestoreOrderRepository implements OrderRepository {
  final FirestoreService _firestore;

  const FirestoreOrderRepository(this._firestore);

  @override
  Future<void> saveOrder(String userId, OrderEntity order) => _firestore
      .saveOrder(userId: userId, order: OrderModel.fromEntity(order).toJson());

  @override
  Stream<List<OrderEntity>> watchOrders(String userId) => _firestore
      .watchOrders(userId)
      .map(
        (snapshot) => snapshot.docs
            .map((document) => OrderModel.fromJson(document.data()).toEntity())
            .toList(),
      );
}
