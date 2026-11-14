
import 'dart:async';

import 'package:flutter/material.dart';


import '../ models/product.dart';
import '../screens/product_details_screen.dart';
import '../services/product_service.dart';

class FlashSaleSection extends StatefulWidget {
  const FlashSaleSection({super.key});

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection> {
  final ProductService _service = ProductService();

  void _openProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(
          product: product,
        ),
      ),
    );
  }

  late Future<List<Product>> _productsFuture;

  Timer? _timer;

  // Demo countdown: 6 hours
  Duration _remainingTime = const Duration(hours: 6);

  @override
  void initState() {
    super.initState();

    _productsFuture = _fetchFlashSaleProducts();

    _startCountdown();
  }

  // Fetch products and sort by highest discount
  Future<List<Product>> _fetchFlashSaleProducts() async {
    final products = await _service.fetchProducts();

    products.sort(
          (a, b) => b.discountPercentage.compareTo(
        a.discountPercentage,
      ),
    );

    return products
        .where((product) => product.discountPercentage > 0)
        .take(10)
        .toList();
  }

  // Countdown timer
  void _startCountdown() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) return;

        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime -= const Duration(seconds: 1);
          } else {
            timer.cancel();
          }
        });
      },
    );
  }

  String _formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }

  String get _countdown {
    final hours = _remainingTime.inHours;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return '${_formatTime(hours)}:'
        '${_formatTime(minutes)}:'
        '${_formatTime(seconds)}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Heading
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFFF6B35),
                  size: 23,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flash Sale',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Grab the best deals before they end',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Countdown
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Color(0xFFFF6B35),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _countdown,
                      style: const TextStyle(
                        color: Color(0xFFE85D25),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Products
        SizedBox(
          height: 240,
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF16834A),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Unable to load flash sale',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _productsFuture =
                                _fetchFlashSaleProducts();
                          });
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              final products = snapshot.data ?? [];

              if (products.isEmpty) {
                return const Center(
                  child: Text('No flash sale products found'),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Flash Sale Product Card

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _openProductDetails(product),
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFFF0F0F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(17),
                  ),
                  child: Image.network(
                    product.thumbnail,
                    height: 145,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 145,
                        color: const Color(0xFFF2F4F5),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Discount Badge
                Positioned(
                  top: 9,
                  left: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5630),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF292929),
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '\$${product.discountedPrice.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16834A),
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      Flexible(
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB800),
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Hot Deal',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
