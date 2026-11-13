
class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final String thumbnail;
  final double price;
  final double discountPercentage;
  final double rating;
  final String brand;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.brand,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      price: (json['price'] as num).toDouble(),
      discountPercentage:
      (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      brand: json['brand'] ?? 'Generic',
    );
  }

  double get discountedPrice {
    return price - (price * discountPercentage / 100);
  }
}
