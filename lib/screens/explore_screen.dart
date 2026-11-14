
import 'package:flutter/material.dart';


import '../ models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

class ExploreScreen extends StatefulWidget {
  final String? initialCategorySlug;

  const ExploreScreen({super.key,this.initialCategorySlug,});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}







class _ExploreScreenState extends State<ExploreScreen> {
  final ProductService _service = ProductService();

  final TextEditingController _searchController =
  TextEditingController();

  List<Map<String, String>> categories = [];

  String selectedCategory = 'all';

  Future<List<Product>>? productsFuture;

  bool isLoadingCategories = true;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   productsFuture = _service.fetchProducts();
  //   _loadCategories();
  // }


  @override
  void initState() {
    super.initState();

    selectedCategory = widget.initialCategorySlug ?? 'all';

    productsFuture = selectedCategory == 'all'
        ? _service.fetchProducts()
        : _service.fetchProductsByCategory(selectedCategory);

    _loadCategories();
  }



  // Load categories from API
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
    setState(() {
      selectedCategory = 'all';

      if (query.trim().isEmpty) {
        productsFuture = _service.fetchProducts();
      } else {
        productsFuture = _service.searchProducts(query.trim());
      }
    });
  }

  // Filter by category
  void _selectCategory(String category) {
    FocusScope.of(context).unfocus();

    _searchController.clear();

    setState(() {
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
    setState(() {
      productsFuture = selectedCategory == 'all'
          ? _service.fetchProducts()
          : _service.fetchProductsByCategory(selectedCategory);
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

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _searchProducts,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchProducts(_searchController.text);
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
                  _buildCategoryChip(
                    'All',
                    'all',
                  ),

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

            // Products Heading
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discover Products',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    selectedCategory == 'all'
                        ? 'All Products'
                        : selectedCategory.replaceAll('-', ' '),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
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

  // Category Chip Widget
  Widget _buildCategoryChip(
      String title,
      String slug,
      ) {
    final isSelected = selectedCategory == slug;

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

  // Error State
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
            onPressed: () {
              _refreshProducts();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 55,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try another search or category.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
