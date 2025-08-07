import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_repository.dart';
import '../../data/models/product_isar.dart';
import '../../domain/entities/product_entity.dart';

// Repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Product list provider
final productListProvider = FutureProvider<List<ProductIsar>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getAllProducts();
});

// Product by ID provider
final productByIdProvider = Provider.family<AsyncValue<ProductIsar?>, int>((ref, id) {
  final productList = ref.watch(productListProvider);
  return productList.when(
    data: (products) {
      try {
        final product = products.firstWhere((p) => p.id == id);
        return AsyncValue.data(product);
      } catch (e) {
        return const AsyncValue.data(null);
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Categories provider (static for now)
final categoriesProvider = Provider<List<String>>((ref) {
  return ['Cupcakes', 'Cake Slices', 'Cake Tasters', 'Cake Pops'];
});

// Products by category provider
final productsByCategoryProvider = Provider.family<AsyncValue<List<ProductIsar>>, String>((ref, category) {
  final productList = ref.watch(productListProvider);
  return productList.when(
    data: (products) {
      final filtered = products.where((p) => p.category == category).toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Search products provider
final searchProductsProvider = Provider.family<AsyncValue<List<ProductIsar>>, String>((ref, query) {
  final productList = ref.watch(productListProvider);
  return productList.when(
    data: (products) {
      if (query.isEmpty) return AsyncValue.data(products);
      final filtered = products.where((p) => 
        p.name.toLowerCase().contains(query.toLowerCase()) ||
        p.description.toLowerCase().contains(query.toLowerCase()) ||
        p.category.toLowerCase().contains(query.toLowerCase())
      ).toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Product management state notifier for admin
class ProductManagementNotifier extends StateNotifier<AsyncValue<List<ProductIsar>>> {
  final ProductRepository repository;

  ProductManagementNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      state = const AsyncValue.loading();
      final products = await repository.getAllProducts();
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addProduct(ProductIsar product) async {
    try {
      await repository.addOrUpdateProduct(product);
      await loadProducts(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProduct(ProductIsar product) async {
    try {
      await repository.addOrUpdateProduct(product);
      await loadProducts(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await repository.deleteProduct(id);
      await loadProducts(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final productManagementProvider = StateNotifierProvider<ProductManagementNotifier, AsyncValue<List<ProductIsar>>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductManagementNotifier(repository);
});