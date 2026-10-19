import '../../domain/repositories/payment_processor.dart';

/// Cash on delivery needs no external payment SDK; settlement happens at handoff.
class CashPaymentProcessor implements PaymentProcessor {
  @override
  String get methodName => 'cash';

  @override
  Future<void> pay(double amountEgp) async {
    if (amountEgp < 0) throw ArgumentError.value(amountEgp, 'amountEgp');
  }
}
