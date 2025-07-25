import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = [
      {'name': 'Chocolate Cupcake', 'price': 3.5, 'image': Icons.cake},
      {'name': 'Vanilla Cupcake', 'price': 3.0, 'image': Icons.icecream},
      {'name': 'Cinnamon Swirl', 'price': 4.0, 'image': Icons.local_cafe},
      {'name': 'Berry Blast', 'price': 4.5, 'image': Icons.local_pizza},
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupcakes'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
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
                        name: product['name'] as String,
                        price: product['price'] as double,
                        description:
                            'A delicious ${product['name']} cupcake, perfect for any occasion!',
                        image: product['image'] as IconData,
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
                      Icon(
                        product['image'] as IconData,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ' 24${product['price']}',
                        style: TextStyle(fontSize: 16, color: AppColors.button),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: Navigate to add product (admin only)
        },
      ),
    );
  }
}
