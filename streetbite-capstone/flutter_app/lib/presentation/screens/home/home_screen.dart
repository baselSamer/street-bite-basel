import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_bite_test/injection.dart';
import 'package:street_bite_test/presentation/blocs/theme/theme_cubit.dart';
import '../../../domain/entities/home/meal_entity.dart';
import '../../blocs/home/meals_cubit.dart';
import '../../blocs/home/meals_state.dart';
import '../../widgets/home/featured_banner_widget.dart';
import '../../widgets/home/hot_offers_widget.dart';
import '../../widgets/home/meal_grid_widget.dart';
import '../vendors/nearby_vendors_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<MealsCubit>()..loadMeals(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'appName'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              tooltip: 'nearbyVendors'.tr(),
              icon: const Icon(Icons.map_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NearbyVendorsScreen(),
                ),
              ),
            ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (ctx, mode) {
                final isDark =
                    mode == ThemeMode.dark ||
                    (mode == ThemeMode.system &&
                        MediaQuery.platformBrightnessOf(ctx) ==
                            Brightness.dark);
                return IconButton(
                  tooltip: 'toggleTheme'.tr(),
                  icon: Icon(
                    isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                  onPressed: () => ctx.read<ThemeCubit>().setTheme(
                    isDark ? ThemeMode.light : ThemeMode.dark,
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<MealsCubit, MealsState>(
          builder: (ctx, state) {
            if (state is MealsInitial || state is MealsLoading) {
              return const _LoadingBody();
            }
            if (state is MealsError) {
              return _ErrorBody(messageKey: state.messageKey);
            }
            if (state is MealsEmpty) {
              return Center(child: Text('noMealsAvailable'.tr()));
            }
            if (state is MealsLoaded) {
              return _HomeBody(meals: state.meals);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Loading ───────────────────────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  final String messageKey;
  const _ErrorBody({required this.messageKey});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              messageKey.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Success body ──────────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  final List<MealEntity> meals;
  const _HomeBody({required this.meals});

  @override
  Widget build(BuildContext context) {
    // Featured banner: up to first 5 meals.
    final featured = meals.take(5).toList();
    // Always show five offers, cycling only when the API has fewer than ten meals.
    final offers = List<MealEntity>.generate(
      5,
      (index) => meals[(featured.length + index) % meals.length],
    );

    return RefreshIndicator(
      onRefresh: () => context.read<MealsCubit>().refreshMeals(),
      child: CustomScrollView(
        slivers: [
          // ── Featured meals header ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                'featuredMeals'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // ── Featured PageView banner ─────────────────────────────────────────
          SliverToBoxAdapter(child: FeaturedBannerWidget(meals: featured)),

          // ── Hot picks horizontal list ────────────────────────────────────────
          SliverToBoxAdapter(child: HotOffersWidget(meals: offers)),

          // ── Live Menu header ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'liveMenu'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // ── Two-column meals grid ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MealGridWidget(meals: meals),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
