import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth/auth_repository.dart';
import '../../../domain/repositories/favorites_repository.dart';
import '../../../domain/entities/home/meal_entity.dart';
import '../../../domain/usecases/home/get_meals_usecase.dart';
import '../../../injection.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';

class MealDetailsScreen extends StatefulWidget {
  final MealEntity meal;

  const MealDetailsScreen({super.key, required this.meal});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  late Future<MealEntity?> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = getIt<GetMealsUseCase>().getDetails(widget.meal.id);
  }

  @override
  void didUpdateWidget(covariant MealDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.meal.id != widget.meal.id) {
      _detailsFuture = getIt<GetMealsUseCase>().getDetails(widget.meal.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    return BlocConsumer<CartBloc, CartState>(
      listenWhen: (previous, current) => current.itemCount > previous.itemCount,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('addedToCart'.tr(namedArgs: {'meal': meal.name})),
          ),
        );
      },
      builder: (context, cartState) => Scaffold(
        appBar: AppBar(
          title: Text(meal.name),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Center(
                child: Badge(
                  label: Text('${cartState.itemCount}'),
                  isLabelVisible: cartState.itemCount > 0,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder<MealEntity?>(
          future: _detailsFuture,
          builder: (context, snapshot) {
            final details = snapshot.data ?? meal;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('mealDetailsError'.tr()));
            }
            return ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                AspectRatio(
                  aspectRatio: 1.4,
                  child: Image.network(
                    details.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(Icons.broken_image_outlined, size: 48),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              details.name,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            tooltip: 'saveFavorite'.tr(),
                            icon: const Icon(Icons.favorite_border_rounded),
                            onPressed: () => _saveFavorite(context, details),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${'mealCategory'.tr()}: ${details.category}'),
                      Text('${'mealArea'.tr()}: ${details.area}'),
                      const SizedBox(height: 20),
                      Text(
                        'mealInstructions'.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        details.instructions?.trim().isNotEmpty == true
                            ? details.instructions!.trim()
                            : 'mealInstructionsUnavailable'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () =>
                              context.read<CartBloc>().add(CartItemAdded(meal)),
                          icon: const Icon(Icons.add_shopping_cart),
                          label: Text('addToCart'.tr()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveFavorite(BuildContext context, MealEntity meal) async {
    final userId = getIt<AuthRepository>().currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('signInToSaveFavorite'.tr())));
      return;
    }
    try {
      await getIt<FavoritesRepository>().setFavorite(userId, meal, true);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('favoriteSaved'.tr())));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('firebaseSaveError'.tr())));
      }
    }
  }
}
