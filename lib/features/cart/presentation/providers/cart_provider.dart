import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/cart_repository.dart';
import '../../data/models/cart_item_isar.dart';
import '../../../products/data/models/product_isar.dart';

// Repository provider
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

// Cart state
class CartState {
  final List<CartItemIsar> items;
  final bool isLoading;
  final String? error;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({
    List<CartItemIsar>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  double get totalPrice {
    return items.fold(0.0, (total, item) => total + (item.price * item.quantity));
  }

  int get totalItems {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  bool get isEmpty => items.isEmpty;
}

// Cart notifier
class CartNotifier extends StateNotifier<CartState> {
  final CartRepository repository;

  CartNotifier(this.repository) : super(const CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final items = await repository.getAllCartItems();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load cart: ${e.toString()}',
      );
    }
  }

  Future<void> addToCart(ProductIsar product, {int quantity = 1}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Check if item already exists in cart
      final existingItemIndex = state.items.indexWhere(
        (item) => item.productId == product.id,
      );

      if (existingItemIndex != -1) {
        // Update existing item quantity
        final existingItem = state.items[existingItemIndex];
        final updatedItem = CartItemIsar()
          ..id = existingItem.id
          ..productId = existingItem.productId
          ..name = existingItem.name
          ..price = existingItem.price
          ..quantity = existingItem.quantity + quantity
          ..category = existingItem.category
          ..imageUrl = existingItem.imageUrl;
        
        await repository.addOrUpdateCartItem(updatedItem);
      } else {
        // Add new item
        final cartItem = CartItemIsar()
          ..productId = product.id
          ..name = product.name
          ..price = product.price
          ..quantity = quantity
          ..category = product.category
          ..imageUrl = product.images.isNotEmpty ? product.images.first : '';
        
        await repository.addOrUpdateCartItem(cartItem);
      }

      await loadCart(); // Refresh cart
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add item to cart: ${e.toString()}',
      );
    }
  }

  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(cartItemId);
        return;
      }

      state = state.copyWith(isLoading: true, error: null);
      
      final itemIndex = state.items.indexWhere((item) => item.id == cartItemId);
      if (itemIndex != -1) {
        final item = state.items[itemIndex];
        final updatedItem = CartItemIsar()
          ..id = item.id
          ..productId = item.productId
          ..name = item.name
          ..price = item.price
          ..quantity = newQuantity
          ..category = item.category
          ..imageUrl = item.imageUrl;
        
        await repository.addOrUpdateCartItem(updatedItem);
        await loadCart(); // Refresh cart
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update item quantity: ${e.toString()}',
      );
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await repository.deleteCartItem(cartItemId);
      await loadCart(); // Refresh cart
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to remove item from cart: ${e.toString()}',
      );
    }
  }

  Future<void> clearCart() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Delete all items
      for (final item in state.items) {
        await repository.deleteCartItem(item.id);
      }
      
      await loadCart(); // Refresh cart
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to clear cart: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(repository);
});

// Convenience providers
final cartItemsProvider = Provider<List<CartItemIsar>>((ref) {
  return ref.watch(cartProvider).items;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).totalPrice;
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalItems;
});

final cartIsEmptyProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isEmpty;
});

final cartLoadingProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isLoading;
});

final cartErrorProvider = Provider<String?>((ref) {
  return ref.watch(cartProvider).error;
});