
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ models/cart_item.dart';
import '../providers/cart_provider.dart';


const Color primaryGreen = Color(0xFF75F54A);
const Color darkText = Color(0xFF171A16);
const Color lightBackground = Color(0xFFF7F8F6);

class CartScreen extends StatelessWidget {
  final VoidCallback? onContinueShopping;

  const CartScreen({
    super.key,
    this.onContinueShopping,
  });

  String price(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: darkText,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '${cart.totalItems} Items',
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return _emptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
                  children: [
                    const Text(
                      'Your products',
                      style: TextStyle(
                        color: darkText,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),

                    ...cart.items.map(
                          (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 13),
                        child: _productCard(context, item, cart),
                      ),
                    ),

                    const SizedBox(height: 8),
                    _deliveryMessage(cart),
                    const SizedBox(height: 20),
                    _orderSummary(cart),
                  ],
                ),
              ),
              _checkoutSection(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _productCard(
      BuildContext context,
      CartItem item,
      CartProvider cart,
      ) {
    final product = item.product;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFEEEEEA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 112,
            width: 104,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_outlined,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                          color: darkText,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => cart.removeItem(product.id),
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                          size: 19,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  product.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  price(product.discountedPrice),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _quantityControl(
                      icon: Icons.remove,
                      onTap: () => cart.decreaseQuantity(product.id),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: darkText,
                        ),
                      ),
                    ),
                    _quantityControl(
                      icon: Icons.add,
                      onTap: () => cart.increaseQuantity(product.id),
                      filled: true,
                    ),
                    const Spacer(),
                    Text(
                      price(item.totalPrice),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A6255),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityControl({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 29,
        width: 29,
        decoration: BoxDecoration(
          color: filled ? primaryGreen : const Color(0xFFF0F1ED),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 16,
          color: darkText,
        ),
      ),
    );
  }

  Widget _deliveryMessage(CartProvider cart) {
    final isFree = cart.deliveryFee == 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFFE9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            color: Color(0xFF3C8B25),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isFree
                  ? 'Great! You have free delivery.'
                  : 'Add more products to unlock free delivery.',
              style: const TextStyle(
                color: Color(0xFF315D25),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isFree)
            const Icon(
              Icons.check_circle,
              color: Color(0xFF3C8B25),
              size: 18,
            ),
        ],
      ),
    );
  }

  Widget _orderSummary(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFEEEEEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: darkText,
            ),
          ),
          const SizedBox(height: 17),
          _summaryRow('Subtotal', price(cart.subtotal)),
          const SizedBox(height: 12),
          _summaryRow(
            'Delivery Fee',
            cart.deliveryFee == 0 ? 'FREE' : price(cart.deliveryFee),
            valueColor: const Color(0xFF3C8B25),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(
              color: Color(0xFFEEEEEA),
              height: 1,
            ),
          ),
          _summaryRow(
            'Total Amount',
            price(cart.total),
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
      String title,
      String value, {
        bool bold = false,
        Color? valueColor,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: bold ? 14 : 13,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            color: bold ? darkText : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 17 : 13,
            fontWeight: FontWeight.w800,
            color: valueColor ?? darkText,
          ),
        ),
      ],
    );
  }

  Widget _checkoutSection(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 15, 18, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEA)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checkout will be available soon.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: darkText,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  '• ${price(cart.total)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 7),
                const Icon(Icons.arrow_forward_rounded, size: 19),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 145,
              width: 145,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 68,
                color: darkText,
              ),
            ),
            const SizedBox(height: 27),
            const Text(
              'Your cart is empty!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: darkText,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Looks like you haven’t added anything to your cart yet. Explore products and find something you love.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 49,
              child: ElevatedButton(
                onPressed: onContinueShopping,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: darkText,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Start Shopping',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
