import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/order/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/auth/auth_repository.dart';
import '../../injection.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = getIt<AuthRepository>().currentUser?.id;
    if (userId == null) return Center(child: Text('ordersEmpty'.tr()));

    return Scaffold(
      appBar: AppBar(title: Text('ordersTab'.tr())),
      body: StreamBuilder<List<OrderEntity>>(
        stream: getIt<OrderRepository>().watchOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('firebaseLoadError'.tr()));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          if (orders.isEmpty) return Center(child: Text('ordersEmpty'.tr()));
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(
                    'orderNumber'.tr(namedArgs: {'number': '${index + 1}'}),
                  ),
                  subtitle: Text(
                    'orderItemsCount'.tr(
                      namedArgs: {'count': '${order.items.length}'},
                    ),
                  ),
                  trailing: Text(
                    order.status == 'placed'
                        ? 'orderStatusPlaced'.tr()
                        : 'orderStatusUnknown'.tr(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
