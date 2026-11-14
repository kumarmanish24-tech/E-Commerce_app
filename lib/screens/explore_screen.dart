
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ models/product.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

class ExploreScreen extends StatefulWidget {
  final String? initialCategorySlug;
  final String searchQuery;

  const ExploreScreen({
    super.key,
    this.initialCategorySlug,
    this.searchQuery = '',
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ProductService _service = ProductService();

  final TextEditingController _searchController =
  TextEditingController();

  List<Map<String, String>> categories = [];

  String selectedCategory = 'all';
  String _activeSearchQuery = '';

  Future<List<Product>>? productsFuture;

  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();

    _activeSearchQuery = widget.searchQuery.trim();
    _searchController.text = _activeSearchQuery;

    selectedCategory = _activeSearchQuery.isNotEmpty
        ? 'all'
        : widget.initialCategorySlug ?? 'all';

    _loadInitialProducts();
    _loadCategories();
  }

  // Initial products
  void _loadInitialProducts() {
    if (_activeSearchQuery.isNotEmpty) {
      productsFuture =
          _service.searchProducts(_activeSearchQuery);
    } else if (selectedCategory == 'all') {
      productsFuture = _service.fetchProducts();
    } else {
      productsFuture =
          _service.fetchProductsByCategory(selectedCategory);
    }
  }

  // Load categories
  Future<void> _loadCategories() async {
    try {
      final result = await _service.fetchCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
        isLoadingCategories = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  // Search products
  void _searchProducts(String query) {
    final searchText = query.trim();

    FocusScope.of(context).unfocus();

    setState(() {
      _activeSearchQuery = searchText;
      selectedCategory = 'all';

      if (searchText.isEmpty) {
        productsFuture = _service.fetchProducts();
      } else {
        productsFuture = _service.searchProducts(searchText);
      }
    });
  }

  // Clear search
  void _clearSearch() {
    _searchController.clear();
    _searchProducts('');
  }

  // Category selection
  void _selectCategory(String category) {
    FocusScope.of(context).unfocus();

    _searchController.clear();

    setState(() {
      _activeSearchQuery = '';
      selectedCategory = category;

      if (category == 'all') {
        productsFuture = _service.fetchProducts();
      } else {
        productsFuture =
            _service.fetchProductsByCategory(category);
      }
    });
  }

  // Refresh products
  Future<void> _refreshProducts() async {
    final query = _activeSearchQuery;

    setState(() {
      if (query.isNotEmpty) {
        productsFuture = _service.searchProducts(query);
      } else if (selectedCategory == 'all') {
        productsFuture = _service.fetchProducts();
      } else {
        productsFuture =
            _service.fetchProductsByCategory(selectedCategory);
      }
    });

    try {
      await productsFuture;
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _activeSearchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFC),
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Color(0xFF171717),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.tune,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _searchProducts,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),

                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.close),
                  )
                      : IconButton(
                    onPressed: () {
                      _searchProducts(
                        _searchController.text,
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Categories
            SizedBox(
              height: 55,
              child: isLoadingCategories
                  ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
                  : ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                children: [
                  _buildCategoryChip('All', 'all'),

                  ...categories.map((category) {
                    return _buildCategoryChip(
                      category['name']!,
                      category['slug']!,
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Products heading
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isSearching
                          ? 'Search Results'
                          : 'Discover Products',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Flexible(
                    child: Text(
                      isSearching
                          ? '"$_activeSearchQuery"'
                          : selectedCategory == 'all'
                          ? 'All Products'
                          : selectedCategory.replaceAll('-', ' '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Product Grid
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: productsFuture,
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
                    return _buildErrorState();
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshProducts,
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        4,
                        16,
                        20,
                      ),
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return ProductCard(
                          product: product,
                          onAdd: () {
                            context
                                .read<CartProvider>()
                                .addToCart(product);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.title} added to cart',
                                ),
                                duration:
                                const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category chip
  Widget _buildCategoryChip(
      String title,
      String slug,
      ) {
    final isSelected = selectedCategory == slug &&
        _activeSearchQuery.isEmpty;

    return GestureDetector(
      onTap: () => _selectCategory(slug),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF202320)
              : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              const Icon(
                Icons.grid_view,
                color: Color(0xFF75F54A),
                size: 17,
              ),
              const SizedBox(width: 6),
            ],

            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Error state
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: 55,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          const Text('Unable to load products'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _refreshProducts,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  // Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 65,
            color: Colors.grey,
          ),
          const SizedBox(height: 14),
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Try another search or category.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _clearSearch,
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }
}
