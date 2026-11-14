
import 'package:flutter/material.dart';

import '../widgets/flash_sale_section.dart';
import '../widgets/promo_banner_carousel.dart';
import '../widgets/recommended_products.dart';
import '../widgets/shop_by_category.dart';
import '../widgets/trending_now_section.dart';

class HomeScreen extends StatelessWidget {
  final Function(String slug) onCategorySelected;
  final ValueChanged<String> onSearch;

  const HomeScreen({
    super.key,
    required this.onCategorySelected,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: const Text(
          'ShopEase',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 2,
          right: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextField(
                      textInputAction: TextInputAction.search,

                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          onSearch(value.trim());
                        }
                      },

                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(Icons.search),

                        filled: true,
                        fillColor: Colors.white,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: Colors.black54,
                            width: 1.5,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: Color(0xFF237E04),
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                ),

                const SizedBox(width: 10),
              ],
            ),

            // Promo Banner
            const SizedBox(height: 20),

            const PromoBannerCarousel(),

            const SizedBox(height: 20),

            // Shop By Category
            ShopByCategory(
              onCategoryTap: onCategorySelected,
            ),

            const FlashSaleSection(),

            const SizedBox(height: 24),

            // Recommended Products
            const RecommendedProducts(),

            const SizedBox(height: 25),

            // Trending Products
            const TrendingNowSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
