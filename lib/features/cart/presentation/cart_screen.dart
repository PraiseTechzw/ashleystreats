import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/cart_provider.dart';
import '../../../core/constants/colors.dart';
import '../data/cart_item_model.dart';
import '../../../core/constants/app_routes.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    double total = cartItems.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty! 🧁',
                style: TextStyle(fontSize: 20, color: AppColors.secondary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.cake,
                      color: AppColors.primary,
                    ), // Placeholder for image
                    title: Text(
                      item.name,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '₦${item.price} x ${item.quantity}',
                      style: TextStyle(color: AppColors.button),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: item.quantity > 1
                              ? () => cartNotifier.updateQuantity(
                                  item.id,
                                  item.quantity - 1,
                                )
                              : null,
                        ),
                        Text(
                          '${item.quantity}',
                          style: TextStyle(color: AppColors.secondary),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => cartNotifier.updateQuantity(
                            item.id,
                            item.quantity + 1,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => cartNotifier.removeFromCart(item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total: ₦${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.checkout);
                    },
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
    );
  }
}
