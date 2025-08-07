import 'package:isar/isar.dart';

import 'models/order_isar.dart';
import '../../../services/isar/isar_service.dart';

class OrderRepository {
  final IsarService _isarService = IsarService();

  Future<List<OrderIsar>> getAllOrders() async {
    final isar = await _isarService.isar;
    return await isar.orderIsars.where().sortByOrderDateDesc().findAll();
  }

  Future<List<OrderIsar>> getOrdersByUserId(String userId) async {
    final isar = await _isarService.isar;
    return await isar.orderIsars
        .filter()
        .userIdEqualTo(userId)
        .sortByOrderDateDesc()
        .findAll();
  }

  Future<OrderIsar?> getOrderById(String orderId) async {
    final isar = await _isarService.isar;
    return await isar.orderIsars
        .filter()
        .orderIdEqualTo(orderId)
        .findFirst();
  }

  Future<void> addOrder(OrderIsar order) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      await isar.orderIsars.put(order);
    });
  }

  Future<void> updateOrder(OrderIsar order) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      await isar.orderIsars.put(order);
    });
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      final order = await isar.orderIsars
          .filter()
          .orderIdEqualTo(orderId)
          .findFirst();
      if (order != null) {
        order.status = newStatus;
        await isar.orderIsars.put(order);
      }
    });
  }

  Future<void> deleteOrder(String orderId) async {
    final isar = await _isarService.isar;
    await isar.writeTxn(() async {
      final order = await isar.orderIsars
          .filter()
          .orderIdEqualTo(orderId)
          .findFirst();
      if (order != null) {
        await isar.orderIsars.delete(order.id);
      }
    });
  }
}
