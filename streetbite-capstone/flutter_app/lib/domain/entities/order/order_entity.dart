class OrderItemEntity {
  final String mealId;
  final String name;
  final int quantity;
  final double unitPriceEgp;

  const OrderItemEntity({
    required this.mealId,
    required this.name,
    required this.quantity,
    required this.unitPriceEgp,
  });
}

class OrderEntity {
  final List<OrderItemEntity> items;
  final double totalPriceEgp;
  final String paymentMethod;
  final String status;

  const OrderEntity({
    required this.items,
    required this.totalPriceEgp,
    required this.paymentMethod,
    required this.status,
  });
}
