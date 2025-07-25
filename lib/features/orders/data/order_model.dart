import 'package:isar/isar.dart';
import 'order_item_embedded.dart';
part 'order_model.g.dart';

@collection
class OrderModel {
  Id id = Isar.autoIncrement;
  late List<OrderItemEmbedded> items;
  late double total;
  late String address;
  late String phone;
  late String deliveryTime;
  late String status; // Pending, Preparing, Delivered
  late DateTime createdAt;

  OrderModel();

  OrderModel.full({
    this.id = Isar.autoIncrement,
    required this.items,
    required this.total,
    required this.address,
    required this.phone,
    required this.deliveryTime,
    required this.status,
    required this.createdAt,
  });
}
