import 'package:flutter/material.dart';
import '../../../services/local_db/isar_service.dart';
import '../data/product_model.dart';
import '../../../core/constants/colors.dart';
import 'admin_product_edit_screen.dart';

class AdminProductListScreen extends StatefulWidget {
  const AdminProductListScreen({Key? key}) : super(key: key);

  @override
  State<AdminProductListScreen> createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _productsFuture = IsarService().getProducts();
    });
  }

  Future<void> _deleteProduct(int id) async {
    await IsarService().deleteProduct(id);
    _refresh();
  }

  void _editProduct(ProductModel? product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminProductEditScreen(product: product),
      ),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
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
                'No products yet! 🧁',
                style: TextStyle(fontSize: 20, color: AppColors.secondary),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                color: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: product.image.isNotEmpty
                      ? Image.network(
                          product.image,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.cake, color: AppColors.primary),
                        )
                      : Icon(Icons.cake, color: AppColors.primary),
                  title: Text(
                    product.name,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '₦${product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: AppColors.button),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _editProduct(product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(product.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () => _editProduct(null),
      ),
    );
  }
}
