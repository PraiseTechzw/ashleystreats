import 'package:isar/isar.dart';
import 'models/product_isar.dart';
import '../../../services/isar/isar_service.dart';

class ProductRepository {
  final IsarService _isarService = IsarService();

  Future<List<ProductIsar>> getAllProducts() async {
    final isar = await _isarService.isar;
    return await isar.productIsars.where().findAll();
  }

  Future<ProductIsar?> getProductById(int id) async {
    final isar = await _isarService.isar;
    return await isar.productIsars.get(id);
  }

  Future<List<ProductIsar>> getProductsByCategory(String category) async {
    final isar = await _isarService.isar;
    return await isar.productIsars
        .filter()
        .categoryEqualTo(category)
        .findAll();
  }

  Future<List<ProductIsar>> searchProducts(String query) async {
    final isar = await _isarService.isar;
    return await isar.productIsars
        .filter()
        .nameContains(query, caseSensitive: false)
        .or()
        .descriptionContains(query, caseSensitive: false)
        .findAll();
  }

  Future<void> addOrUpdateProduct(ProductIsar product) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      await isar.productIsars.put(product);
    });
  }

  Future<void> deleteProduct(int id) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      await isar.productIsars.delete(id);
    });
  }

  Future<void> updateProductAvailability(int id, bool availability) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      final product = await isar.productIsars.get(id);
      if (product != null) {
        product.availability = availability;
        product.updatedAt = DateTime.now();
        await isar.productIsars.put(product);
      }
    });
  }

  Future<void> updateProductStock(int id, int stockQuantity) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      final product = await isar.productIsars.get(id);
      if (product != null) {
        product.stockQuantity = stockQuantity;
        product.updatedAt = DateTime.now();
        await isar.productIsars.put(product);
      }
    });
  }
}
