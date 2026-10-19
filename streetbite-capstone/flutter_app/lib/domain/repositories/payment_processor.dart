/// Payment abstraction: checkout depends on this contract rather than a
/// particular provider, following dependency inversion.
abstract interface class PaymentProcessor {
  String get methodName;

  Future<void> pay(double amountEgp);
}
