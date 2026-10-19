import '../../../domain/entities/order/order_entity.dart';

/// Firestore order serializer kept in the data layer.
class OrderModel {
  final List<OrderItemEntity> items;
  final double totalPriceEgp;
  final String paymentMethod;
  final String status;

  const OrderModel({
    required this.items,
    required this.totalPriceEgp,
    required this.paymentMethod,
    required this.status,
  });

  factory OrderModel.fromEntity(OrderEntity entity) => OrderModel(
    items: entity.items,
    totalPriceEgp: entity.totalPriceEgp,
    paymentMethod: entity.paymentMethod,
    status: entity.status,
  );

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    items: (json['items'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => OrderItemEntity(
            mealId: item['mealId'] as String? ?? '',
            name: item['name'] as String? ?? '',
            quantity: (item['quantity'] as num?)?.toInt() ?? 0,
            unitPriceEgp: (item['unitPriceEgp'] as num?)?.toDouble() ?? 0,
          ),
        )
        .toList(),
    totalPriceEgp: (json['totalPriceEgp'] as num?)?.toDouble() ?? 0,
    paymentMethod: json['paymentMethod'] as String? ?? 'cash',
    status: json['status'] as String? ?? 'placed',
  );

  Map<String, dynamic> toJson() => {
    'items': items
        .map(
          (item) => {
            'mealId': item.mealId,
            'name': item.name,
            'quantity': item.quantity,
            'unitPriceEgp': item.unitPriceEgp,
          },
        )
        .toList(),
    'totalPriceEgp': totalPriceEgp,
    'paymentMethod': paymentMethod,
    'status': status,
  };

  OrderEntity toEntity() => OrderEntity(
    items: items,
    totalPriceEgp: totalPriceEgp,
    paymentMethod: paymentMethod,
    status: status,
  );
}
