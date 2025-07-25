import 'package:isar/isar.dart';
import 'models/product_isar.dart';
import '../../../services/isar/isar_service.dart';

class ProductRepository {
  final IsarService _isarService = IsarService();

  Future<List<ProductIsar>> getAllProducts() async {
    final isar = await _isarService.isar;
    return await isar.productIsars.where().findAll();
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
}
