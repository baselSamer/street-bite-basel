import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/order/place_order_usecase.dart';
import '../../../injection.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.itemCount > 0 && current.itemCount == 0,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('cartBecameEmpty'.tr())));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'cartTitle'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (ctx, state) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Theme.of(ctx).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'cartEmpty'.tr(),
                      style: Theme.of(ctx).textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (ctx, idx) {
                final item = state.items[idx];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.meal.thumbnailUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, _) => Container(
                        width: 56,
                        height: 56,
                        color: Theme.of(
                          ctx,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    item.meal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.meal.category,
                    style: Theme.of(ctx).textTheme.bodySmall,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '×${item.quantity}',
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        tooltip: 'removeItem'.tr(),
                        icon: Icon(
                          Icons.remove_circle_outline_rounded,
                          color: Theme.of(ctx).colorScheme.error,
                        ),
                        onPressed: () => ctx.read<CartBloc>().add(
                          CartItemRemoved(item.meal.id),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) return const SizedBox.shrink();
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'samplePricingNotice'.tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: Text('cartTotal'.tr())),
                        Text(
                          '${state.totalPriceEgp.toStringAsFixed(2)} ${'currencyEgp'.tr()}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _placeOrder(context, state),
                        child: Text('placeOrder'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context, CartState state) async {
    final userId = getIt<AuthRepository>().currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('signInToOrder'.tr())));
      return;
    }
    try {
      await getIt<PlaceOrderUseCase>()(userId: userId, items: state.items);
      if (!context.mounted) return;
      context.read<CartBloc>().add(const CartCleared());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('orderPlaced'.tr())));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('firebaseSaveError'.tr())));
    }
  }
}
