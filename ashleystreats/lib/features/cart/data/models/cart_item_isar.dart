import 'package:isar/isar.dart';
part 'cart_item_isar.g.dart';

@Collection()
class CartItemIsar {
  Id id = Isar.autoIncrement;
  late int productId;
  late int quantity;
  // Add more fields as needed
}
