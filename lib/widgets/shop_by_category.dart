
import 'package:flutter/material.dart';


import '../ models/product.dart';
import '../services/product_service.dart';

class ShopByCategory extends StatefulWidget {
  final Function(String slug) onCategoryTap;

  const ShopByCategory({
    super.key,
    required this.onCategoryTap,
  });

  @override
  State<ShopByCategory> createState() => _ShopByCategoryState();
}

class _ShopByCategoryState extends State<ShopByCategory> {
  final ProductService _service = ProductService();

  late Future<List<dynamic>> _categories;

  final Map<String, Future<List<Product>>> _categoryProducts = {};

  @override
  void initState() {
    super.initState();
    _categories = _service.fetchCategories();
  }

  Future<List<Product>> _getCategoryProducts(String slug) {
    return _categoryProducts.putIfAbsent(
      slug,
          () => _service.fetchProductsByCategory(slug),
    );
  }

  Widget _buildCategoryImage(String slug) {
    return FutureBuilder<List<Product>>(
      future: _getCategoryProducts(slug),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF16834A),
              ),
            ),
          );
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 28,
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            snapshot.data!.first.thumbnail,
            width: 76,
            height: 76,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey,
              );
            },
          ),
        );
      },
    );
  }

  String _formatCategoryName(String name) {
    return name
        .split('-')
        .map(
          (word) => word.isEmpty
          ? word
          : word[0].toUpperCase() + word.substring(1),
    )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shop By Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
              TextButton(
                onPressed: () => widget.onCategoryTap(''),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF16834A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        FutureBuilder<List<dynamic>>(
          future: _categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const SizedBox(
                height: 110,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF16834A),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Unable to load categories'),
              );
            }

            final categories = snapshot.data ?? [];

            if (categories.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No categories found'),
              );
            }

            return SizedBox(
              height: 106,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  final name = category['name']?.toString() ?? '';
                  final slug = category['slug']?.toString() ?? '';

                  return GestureDetector(
                    onTap: () => widget.onCategoryTap(slug),
                    child: SizedBox(
                      width: 70,
                      child: Column(
                        children: [
                          // Container(
                          //   height: 76,
                          //   width: 76,
                          //   decoration: BoxDecoration(
                          //     color: const Color(0xFFF2F4F5),
                          //     borderRadius: BorderRadius.circular(18),
                          //   ),
                          //   child: _buildCategoryImage(slug),
                          // ),


                          Container(
                            height: 56,
                            width: 56,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE8F1EB),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF16834A).withOpacity(0.08),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: _buildCategoryImage(slug),
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            _formatCategoryName(name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
