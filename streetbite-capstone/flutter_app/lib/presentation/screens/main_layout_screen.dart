import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_bite_test/injection.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import './cart/cart_screen.dart';
import './favorites_screen.dart';
import './home/home_screen.dart';
import './orders_screen.dart';
import './profile_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.locale;
  }

  static const List<Widget> _tabs = [
    HomeScreen(),
    FavoritesScreen(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartBloc>(),
      child: Scaffold(
        body: _tabs[_currentIndex],
        bottomNavigationBar: BlocSelector<CartBloc, CartState, int>(
          selector: (state) => state.itemCount,
          builder: (ctx, cartCount) => NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) =>
                setState(() => _currentIndex = index),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: 'homeTab'.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.favorite_outline_rounded),
                selectedIcon: const Icon(Icons.favorite_rounded),
                label: 'favoritesTab'.tr(),
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  child: const Icon(Icons.shopping_cart_rounded),
                ),
                label: 'cartTab'.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.receipt_long_outlined),
                selectedIcon: const Icon(Icons.receipt_long_rounded),
                label: 'ordersTab'.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: 'profileTab'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
