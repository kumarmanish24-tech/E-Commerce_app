
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../ models/product.dart';



class ProductService {
  static const String baseUrl = 'https://dummyjson.com/products';

  // Fetch all products
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl?limit=100'),
    );

    return _handleProductResponse(response);
  }

  // Fetch all categories
  Future<List<Map<String, String>>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((item) {
        return {
          'name': item['name'].toString(),
          'slug': item['slug'].toString(),
        };
      }).toList();
    }

    throw Exception('Failed to load categories');
  }

  // Fetch products by category
  Future<List<Product>> fetchProductsByCategory(
      String category,
      ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/category/${Uri.encodeComponent(category)}',
      ),
    );

    return _handleProductResponse(response);
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/search?q=${Uri.encodeQueryComponent(query)}',
      ),
    );

    return _handleProductResponse(response);
  }

  // Convert JSON response into Product list
  List<Product> _handleProductResponse(
      http.Response response,
      ) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      jsonDecode(response.body);

      final List productsJson = data['products'];

      return productsJson
          .map(
            (item) => Product.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList();
    }

    throw Exception(
      'API Error: ${response.statusCode}',
    );
  }
}
