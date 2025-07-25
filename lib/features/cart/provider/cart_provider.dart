import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cart_item_model.dart';
import '../../../services/local_db/isar_service.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  final IsarService _isarService = IsarService();

  CartNotifier() : super([]) {
    loadCart();
  }

  Future<void> loadCart() async {
    final items = await _isarService.getCartItems();
    state = items;
  }

  Future<void> addToCart(CartItemModel item) async {
    await _isarService.addToCart(item);
    await loadCart();
  }

  Future<void> removeFromCart(int id) async {
    await _isarService.removeFromCart(id);
    await loadCart();
  }

  Future<void> clearCart() async {
    await _isarService.clearCart();
    await loadCart();
  }

  Future<void> updateQuantity(int id, int quantity) async {
    final item = state.firstWhere((e) => e.id == id);
    final updated = CartItemModel.full(
      id: item.id,
      productId: item.productId,
      name: item.name,
      price: item.price,
      quantity: quantity,
      image: item.image,
    );
    await _isarService.addToCart(updated);
    await loadCart();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemModel>>(
  (ref) => CartNotifier(),
);
