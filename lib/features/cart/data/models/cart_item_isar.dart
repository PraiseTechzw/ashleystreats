import 'package:isar/isar.dart';
part 'cart_item_isar.g.dart';

@Collection()
class CartItemIsar {
  Id id = Isar.autoIncrement;
  late int productId;
  late String name;
  late double price;
  late int quantity;
  late String category;
  late String imageUrl;
}
