import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/home/meal_entity.dart';
import '../../../domain/entities/order/order_entity.dart';
import '../../../domain/repositories/favorites_repository.dart';
import '../../../domain/repositories/order_repository.dart';
import '../../../injection.dart';

class ProfileActivitySummary extends StatelessWidget {
  final String userId;

  const ProfileActivitySummary({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<MealEntity>>(
          stream: getIt<FavoritesRepository>().watchFavorites(userId),
          builder: (context, snapshot) => ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text('favoritesTab'.tr()),
            trailing: Text(_count(snapshot)),
          ),
        ),
        StreamBuilder<List<OrderEntity>>(
          stream: getIt<OrderRepository>().watchOrders(userId),
          builder: (context, snapshot) => ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text('ordersTab'.tr()),
            trailing: Text(_count(snapshot)),
          ),
        ),
      ],
    );
  }

  String _count<T>(AsyncSnapshot<List<T>> snapshot) {
    if (snapshot.hasError) return 'firebaseLoadError'.tr();
    if (!snapshot.hasData) return 'loading'.tr();
    return '${snapshot.data!.length}';
  }
}
