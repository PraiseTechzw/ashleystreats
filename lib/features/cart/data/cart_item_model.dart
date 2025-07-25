import 'package:isar/isar.dart';
part 'cart_item_model.g.dart';

@collection
class CartItemModel {
  Id id = Isar.autoIncrement;
  late String productId;
  late String name;
  late double price;
  late int quantity;
  late String image; // Store as string for now (icon name or asset path)

  CartItemModel();

  CartItemModel.full({
    this.id = Isar.autoIncrement,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
}
