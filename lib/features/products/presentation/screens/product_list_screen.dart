import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/product_repository.dart';
import '../../data/models/product_isar.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen>
    with TickerProviderStateMixin {
  final ProductRepository _repo = ProductRepository();
  late Future<List<ProductIsar>> _productsFuture;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Sample data for deals
  final List<Map<String, dynamic>> _deals = [
    {
      'name': 'Cupcakes (5+1)',
      'bakery': 'Mad Batter',
      'price': 12.50,
      'originalPrice': 15.80,
      'image': 'assets/images/cupcakes_deal.jpg',
      'isFavorite': false,
    },
    {
      'name': 'Chocolate Cream',
      'bakery': 'Sweet Dreams',
      'price': 8.99,
      'originalPrice': 12.00,
      'image': 'assets/images/chocolate_cream.jpg',
      'isFavorite': true,
    },
    {
      'name': 'Vanilla Delight',
      'bakery': 'Cupcake Corner',
      'price': 10.50,
      'originalPrice': 14.00,
      'image': 'assets/images/vanilla_delight.jpg',
      'isFavorite': false,
    },
  ];

  // Sample data for categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Cupcakes', 'icon': Icons.cake, 'color': AppColors.primary},
    {
      'name': 'Breads',
      'icon': Icons.breakfast_dining,
      'color': AppColors.secondary,
    },
    {'name': 'Donuts', 'icon': Icons.circle, 'color': AppColors.accent},
    {
      'name': 'Pastries',
      'icon': Icons.cake_outlined,
      'color': AppColors.cardColor,
    },
    {'name': 'Cookies', 'icon': Icons.cookie, 'color': AppColors.primary},
  ];

  // Sample data for popular bakeries
  final List<Map<String, dynamic>> _bakeries = [
    {
      'name': 'The Bradley Baking',
      'logo': 'assets/images/bradley_logo.jpg',
      'hours': '10:00 am - 10:00 pm',
      'distance': '3.5 km',
      'rating': 4.8,
      'est': 'EST. 2017',
    },
    {
      'name': 'Love Donuts',
      'logo': 'assets/images/love_donuts_logo.jpg',
      'hours': '8:00 am - 9:00 pm',
      'distance': '2.1 km',
      'rating': 4.6,
      'est': 'EST. 2019',
    },
    {
      'name': 'Sweet Dreams Bakery',
      'logo': 'assets/images/sweet_dreams_logo.jpg',
      'hours': '9:00 am - 8:00 pm',
      'distance': '4.2 km',
      'rating': 4.9,
      'est': 'EST. 2015',
    },
  ];

  @override
  void initState() {
    super.initState();
    _productsFuture = _repo.getAllProducts();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                // Custom App Bar
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'New York',
                        style: AppTheme.authTitleStyle.copyWith(
                          fontSize: 18,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Navigate to cart
                        },
                      ),
                    ),
                  ],
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Today's Best Deals Section
                        _buildSectionHeader('Today\'s best deals', () {}),
                        const SizedBox(height: 16),
                        _buildDealsSection(),
                        const SizedBox(height: 32),

                        // Discover by Category Section
                        _buildSectionHeader('Discover by category', () {}),
                        const SizedBox(height: 16),
                        _buildCategoriesSection(),
                        const SizedBox(height: 32),

                        // Popular Bakery Section
                        _buildSectionHeader('Popular bakery', () {}),
                        const SizedBox(height: 16),
                        _buildBakeriesSection(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAllPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 24,
            color: AppColors.secondary,
          ),
        ),
        TextButton(
          onPressed: onAllPressed,
          child: Text(
            'All',
            style: AppTheme.elegantBodyStyle.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDealsSection() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _deals.length,
        itemBuilder: (context, index) {
          final deal = _deals[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder with favorite and cart icons
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.cake,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: IconButton(
                          icon: Icon(
                            deal['isFavorite']
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: deal['isFavorite']
                                ? AppColors.accent
                                : AppColors.secondary,
                          ),
                          onPressed: () {
                            setState(() {
                              deal['isFavorite'] = !deal['isFavorite'];
                            });
                          },
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              // Add to cart
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal['name'],
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deal['bakery'],
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 14,
                          color: AppColors.secondary.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$${deal['price']}',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${deal['originalPrice']}',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.secondary.withOpacity(0.5),
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
        },
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: category['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: category['color'].withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    category['icon'],
                    color: category['color'],
                    size: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBakeriesSection() {
    return Column(
      children: _bakeries.map((bakery) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Bakery logo placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.cardColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(Icons.store, color: AppColors.primary, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bakery['name'],
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.secondary.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          bakery['hours'],
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 12,
                            color: AppColors.secondary.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.secondary.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          bakery['distance'],
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 12,
                            color: AppColors.secondary.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        bakery['rating'].toString(),
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bakery['est'],
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 10,
                      color: AppColors.secondary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
