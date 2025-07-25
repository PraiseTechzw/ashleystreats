import 'package:isar/isar.dart';

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
