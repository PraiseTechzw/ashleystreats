import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/provider/cart_provider.dart';
import '../../cart/data/cart_item_model.dart';
import '../../../core/constants/colors.dart';
import 'package:collection/collection.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String? name;
  final double? price;
  final String? description;
  final IconData? image;

  const ProductDetailScreen({
    Key? key,
    this.name,
    this.price,
    this.description,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (name == null || price == null || description == null || image == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Detail')),
        body: const Center(child: Text('No product provided.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(name!), backgroundColor: AppColors.primary),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(image, size: 100, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              name!,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\u20a6$price',
              style: TextStyle(
                fontSize: 22,
                color: AppColors.button,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              description!,
              style: TextStyle(fontSize: 18, color: AppColors.secondary),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  final cartItems = ref.read(cartProvider);
                  final existing = cartItems.firstWhereOrNull(
                    (item) => item.name == name,
                  );
                  if (existing != null) {
                    await ref
                        .read(cartProvider.notifier)
                        .updateQuantity(existing.id, existing.quantity + 1);
                  } else {
                    await ref
                        .read(cartProvider.notifier)
                        .addToCart(
                          CartItemModel.full(
                            productId: name!,
                            name: name!,
                            price: price!,
                            quantity: 1,
                            image: image!.codePoint.toString(),
                          ),
                        );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart!')),
                  );
                },
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
