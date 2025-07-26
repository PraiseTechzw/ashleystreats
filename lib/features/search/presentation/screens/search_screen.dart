import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _results = [];
  String _query = '';

  // Mock product data
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Rainbow Cupcake',
      'price': 4.50,
      'type': 'sweet',
      'image': 'assets/images/cupcakes_deal.jpg',
    },
    {
      'name': 'Cheese Pie',
      'price': 5.00,
      'type': 'savory',
      'image': 'assets/images/cheese_pie.jpg',
    },
    {
      'name': 'Chocolate Chip Cookie',
      'price': 2.50,
      'type': 'sweet',
      'image': 'assets/images/chocolate_cookie.jpg',
    },
    {
      'name': 'Mini Quiche',
      'price': 3.50,
      'type': 'savory',
      'image': 'assets/images/mini_quiche.jpg',
    },
    {
      'name': 'Strawberry Cupcake',
      'price': 4.00,
      'type': 'sweet',
      'image': 'assets/images/strawberry_cupcake.jpg',
    },
    {
      'name': 'Macaron',
      'price': 3.00,
      'type': 'sweet',
      'image': 'assets/images/macaron.jpg',
    },
    {
      'name': 'Red Velvet Cookie',
      'price': 2.80,
      'type': 'sweet',
      'image': 'assets/images/red_velvet_cookie.jpg',
    },
    {
      'name': 'Sausage Roll',
      'price': 3.20,
      'type': 'savory',
      'image': 'assets/images/sausage_roll.jpg',
    },
    {
      'name': 'Cheese Stick',
      'price': 2.90,
      'type': 'savory',
      'image': 'assets/images/cheese_stick.jpg',
    },
  ];

  void _onSearchChanged(String value) async {
    setState(() {
      _isLoading = true;
      _query = value;
    });
    await Future.delayed(const Duration(milliseconds: 400)); // Simulate loading
    final results = _products
        .where((p) => p['name'].toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Search',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 22,
            color: AppColors.secondary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for treats, sweets, or savory...',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              Expanded(
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                    width: 80,
                    height: 80,
                  ),
                ),
              )
            else if (_query.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'Start typing to search for your favorite treats!',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      color: AppColors.secondary.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (_results.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/empty.json',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found for "$_query"',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          color: AppColors.secondary.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final item = _results[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Icon(
                            item['type'] == 'sweet'
                                ? Icons.cake
                                : Icons.lunch_dining,
                            color: item['type'] == 'sweet'
                                ? AppColors.primary
                                : AppColors.cardColor,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item['name'],
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '  ${item['price'].toStringAsFixed(2)}',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: const Size.fromHeight(36),
                              ),
                              child: Text(
                                'Add to Cart',
                                style: AppTheme.buttonTextStyle.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
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
}
