import 'package:flutter/material.dart';
import '../../data/models/product_isar.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductIsar product;
  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrl.isNotEmpty)
              Image.network(product.imageUrl, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(product.description),
            // Add "Add to Cart" button here in the future
          ],
        ),
      ),
    );
  }
}
