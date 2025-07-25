import 'package:isar/isar.dart';
part 'order_model.g.dart';

@embedded
class OrderItemEmbedded {
  late String productId;
  late String name;
  late double price;
  late int quantity;
  late String image;

  OrderItemEmbedded();

  OrderItemEmbedded.full({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
}

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
