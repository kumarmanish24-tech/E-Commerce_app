
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ models/product.dart';


import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import 'product_card.dart';

class RecommendedProducts extends StatefulWidget {
  const RecommendedProducts({super.key});

  @override
  State<RecommendedProducts> createState() =>
      _RecommendedProductsState();
}

class _RecommendedProductsState
    extends State<RecommendedProducts> {
  final ProductService _service = ProductService();

  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _service.fetchRecommendedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended For You',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF171717),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Products you might like',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              TextButton(
                onPressed: () {
                  // Navigate to Explore screen
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Color(0xFF176B35),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Products
        SizedBox(
          height: 260,
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF176B35),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _productsFuture =
                            _service.fetchRecommendedProducts();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry loading products'),
                  ),
                );
              }

              final products = snapshot.data ?? [];

              if (products.isEmpty) {
                return const Center(
                  child: Text('No recommended products'),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                itemCount: products.length,
                separatorBuilder: (_, __) =>
                const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return SizedBox(
                    width: 175,
                    child: ProductCard(
                      product: product,
                      onAdd: () {
                        context.read<CartProvider>().addToCart(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
