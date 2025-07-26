import 'package:isar/isar.dart';
import 'models/cart_item_isar.dart';
import '../../../services/isar/isar_service.dart';

class CartRepository {
  final IsarService _isarService = IsarService();

  Future<List<CartItemIsar>> getAllCartItems() async {
    final isar = await _isarService.isar;
    return await isar.cartItemIsars.where().findAll();
  }

  Future<void> addOrUpdateCartItem(CartItemIsar item) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      await isar.cartItemIsars.put(item);
    });
  }

  Future<void> deleteCartItem(int id) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      await isar.cartItemIsars.delete(id);
    });
  }

  Future<void> clearCart() async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      await isar.cartItemIsars.clear();
    });
  }
}
