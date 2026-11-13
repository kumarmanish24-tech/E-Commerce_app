
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final int index;

  const ProductCard({
    super.key,
    required this.index,
  });

  static const List<Map<String, dynamic>> products = [
    {
      'name': 'Wireless Headphones',
      'price': 1499,
      'icon': Icons.headphones,
    },
    {
      'name': 'Smart Watch',
      'price': 2499,
      'icon': Icons.watch,
    },
    {
      'name': 'Running Shoes',
      'price': 1999,
      'icon': Icons.directions_run,
    },
    {
      'name': 'Backpack',
      'price': 999,
      'icon': Icons.backpack,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final product = products[index % products.length];

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFF0F3F6),
              child: Icon(
                product['icon'],
                size: 65,
                color: const Color(0xFF315C81),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${product['price']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product['name']} added to cart',
                          ),
                        ),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
