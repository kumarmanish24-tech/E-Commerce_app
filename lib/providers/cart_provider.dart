
import 'package:flutter/foundation.dart';

import '../ models/cart_item.dart';
import '../ models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  // Free delivery on orders of $100 or more.
  double get deliveryFee {
    if (_items.isEmpty || subtotal >= 100) return 0;
    return 5;
  }

  double get total => subtotal + deliveryFee;

  bool containsProduct(int productId) => _items.containsKey(productId);

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      final existingItem = _items[product.id]!;
      _items[product.id] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      _items[product.id] = CartItem(product: product);
    }

    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final item = _items[productId];
    if (item == null) return;

    _items[productId] = item.copyWith(
      quantity: item.quantity + 1,
    );
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    final item = _items[productId];
    if (item == null) return;

    if (item.quantity <= 1) {
      removeItem(productId);
      return;
    }

    _items[productId] = item.copyWith(
      quantity: item.quantity - 1,
    );
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
