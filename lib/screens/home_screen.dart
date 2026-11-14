
import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner_carousel.dart';
import '../widgets/recommended_products.dart';
import '../widgets/shop_by_category.dart';
import '../widgets/trending_now_section.dart';

class HomeScreen extends StatelessWidget {
  final Function(String slug) onCategorySelected;

  const HomeScreen({super.key,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {





    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShopEase',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16,bottom: 16,left: 8,right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   'Hello, Manish 👋',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 6),
            // const Text(
            //   'Discover something you will love.',
            //   style: TextStyle(color: Colors.grey),
            // ),
            // const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                IconButton(onPressed: (){}, icon: Icon(Icons.tune)),
                SizedBox(width: 10,),
              ],
            ),

            Column(
              children: [
                const SizedBox(height: 20),

                const PromoBannerCarousel(),

                const SizedBox(height: 20),

                // Other home screen sections
              ],
            ),



            ShopByCategory(
              onCategoryTap: onCategorySelected,
            ),



            const SizedBox(height: 12),

            const RecommendedProducts(),

            const SizedBox(height: 25),

            const TrendingNowSection(),




            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF315C81),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPECIAL OFFER',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Up to 40% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Explore our latest collection.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Featured Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            // GridView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: 4,
            //   gridDelegate:
            //   const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 12,
            //     mainAxisSpacing: 12,
            //     childAspectRatio: 0.72,
            //   ),
            //   itemBuilder: (context, index) {
            //     return ProductCard(index: index, product: null,);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
