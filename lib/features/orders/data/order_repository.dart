import 'package:isar/isar.dart';

import 'models/order_isar.dart';
import '../../../services/isar/isar_service.dart';

class OrderRepository {
  final IsarService _isarService = IsarService();

  Future<List<OrderIsar>> getAllOrders() async {
    final isar = await _isarService.isar;
    return await isar.orderIsars.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> addOrder(OrderIsar order) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      await isar.orderIsars.put(order);
    });
  }
}
