import '../../domain/repositories/payment_processor.dart';

/// Adapter for a card gateway. Supply the gateway's charge function at wiring
/// time; this keeps provider-specific SDK code outside checkout logic.
class CardPaymentProcessor implements PaymentProcessor {
  final Future<void> Function(double amountEgp) _charge;

  const CardPaymentProcessor(this._charge);

  @override
  String get methodName => 'card';

  @override
  Future<void> pay(double amountEgp) => _charge(amountEgp);
}
