import 'package:flutter_test/flutter_test.dart';
import 'package:street_bite_test/domain/entities/cart/cart_item.dart';
import 'package:street_bite_test/domain/entities/order/order_entity.dart';
import 'package:street_bite_test/domain/repositories/order_repository.dart';
import 'package:street_bite_test/domain/repositories/payment_processor.dart';
import 'package:street_bite_test/domain/usecases/order/place_order_usecase.dart';

import 'base_automation.dart';

class _RecordingPayment implements PaymentProcessor {
  double? chargedAmount;
  bool shouldFail = false;

  @override
  String get methodName => 'test-card';

  @override
  Future<void> pay(double amountEgp) async {
    if (shouldFail) throw StateError('payment failed');
    chargedAmount = amountEgp;
  }
}

class _RecordingOrders implements OrderRepository {
  String? savedForUser;
  OrderEntity? savedOrder;

  @override
  Future<void> saveOrder(String userId, OrderEntity order) async {
    savedForUser = userId;
    savedOrder = order;
  }

  @override
  Stream<List<OrderEntity>> watchOrders(String userId) => const Stream.empty();
}

class OrderFlowAutomation extends BaseTest {
  void register() {
    test(
      'charges the selected processor and persists the authenticated order',
      () async {
        final payment = _RecordingPayment();
        final orders = _RecordingOrders();
        final checkout = PlaceOrderUseCase(payment, orders);

        await checkout(
          userId: 'current-user',
          items: [const CartItem(meal: BaseTest.meal, quantity: 2)],
        );

        expect(payment.chargedAmount, 150);
        expect(orders.savedForUser, 'current-user');
        expect(orders.savedOrder?.paymentMethod, 'test-card');
        expect(orders.savedOrder?.items.single.quantity, 2);
        expect(orders.savedOrder?.status, 'placed');
      },
    );

    test('does not save an order when payment fails', () async {
      final payment = _RecordingPayment()..shouldFail = true;
      final orders = _RecordingOrders();
      final checkout = PlaceOrderUseCase(payment, orders);

      await expectLater(
        checkout(
          userId: 'current-user',
          items: [const CartItem(meal: BaseTest.meal, quantity: 1)],
        ),
        throwsStateError,
      );
      expect(orders.savedOrder, isNull);
    });
  }
}

void main() => OrderFlowAutomation().register();
