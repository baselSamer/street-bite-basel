import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/home/meal_entity.dart';
import '../../domain/repositories/auth/auth_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../injection.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = getIt<AuthRepository>().currentUser?.id;
    if (userId == null) return Center(child: Text('favoritesEmpty'.tr()));

    return Scaffold(
      appBar: AppBar(title: Text('favoritesTab'.tr())),
      body: StreamBuilder<List<MealEntity>>(
        stream: getIt<FavoritesRepository>().watchFavorites(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('firebaseLoadError'.tr()));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final meals = snapshot.data!;
          if (meals.isEmpty) {
            return Center(child: Text('favoritesEmpty'.tr()));
          }
          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(meal.thumbnailUrl),
                ),
                title: Text(meal.name),
                subtitle: Text(meal.category),
                trailing: IconButton(
                  tooltip: 'removeItem'.tr(),
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () async {
                    try {
                      await getIt<FavoritesRepository>().setFavorite(
                        userId,
                        meal,
                        false,
                      );
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('firebaseSaveError'.tr())),
                        );
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
