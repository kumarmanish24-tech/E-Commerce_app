
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  String _searchQuery = '';
  String? _selectedCategorySlug;

  // Search from Home Screen
  void _searchProducts(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _searchQuery = query.trim();
      _selectedCategorySlug = null;
      selectedIndex = 1;
    });
  }

  // Category navigation from Home Screen
  void _openCategory(String slug) {
    setState(() {
      _selectedCategorySlug = slug.isEmpty ? null : slug;
      _searchQuery = '';
      selectedIndex = 1;
    });
  }

  Widget _cartIcon(IconData icon, int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: -9,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(
                minWidth: 17,
                minHeight: 17,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onCategorySelected: _openCategory,
        onSearch: _searchProducts,
      ),

      ExploreScreen(
        key: ValueKey('$_selectedCategorySlug|$_searchQuery'),
        initialCategorySlug: _selectedCategorySlug,
        searchQuery: _searchQuery,
      ),

      const CartScreen(),

      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;

                // Clear active search when manually opening Explore
                if (index == 1) {
                  _searchQuery = '';
                  _selectedCategorySlug = null;
                }
              });
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: _cartIcon(
                  Icons.shopping_cart_outlined,
                  cart.totalItems,
                ),
                selectedIcon: _cartIcon(
                  Icons.shopping_cart,
                  cart.totalItems,
                ),
                label: 'Cart',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
