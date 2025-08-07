import 'package:isar/isar.dart';
part 'product_isar.g.dart';

@Collection()
class ProductIsar {
  Id id = Isar.autoIncrement;
  late String productId;
  late String name;
  late String description;
  late String category;
  late double price;
  late List<String> images;
  late List<String> ingredients;
  late bool availability;
  late int stockQuantity;
  late DateTime createdAt;
  late DateTime updatedAt;

  // Additional computed fields
  String get imageUrl => images.isNotEmpty ? images.first : '';
}
