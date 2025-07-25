import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../services/local_db/isar_service.dart';
import '../data/product_model.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = IsarService().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupcakes'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return Center(
              child: Text(
                'No cupcakes available! 🧁',
                style: TextStyle(fontSize: 20, color: AppColors.secondary),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(
                            name: product.name,
                            price: product.price,
                            description: product.description,
                            image:
                                Icons.cake, // For now, always use cupcake icon
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          product.image.isNotEmpty
                              ? Image.network(
                                  product.image,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.cake,
                                    color: AppColors.primary,
                                  ),
                                )
                              : Icon(
                                  Icons.cake,
                                  size: 48,
                                  color: AppColors.primary,
                                ),
                          const SizedBox(height: 16),
                          Text(
                            product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.secondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₦${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.button,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
