import 'package:isar/isar.dart';
part 'product_model.g.dart';

@collection
class ProductModel {
  Id id = Isar.autoIncrement;
  late String name;
  late double price;
  late String description;
  late String image; // Asset path or URL

  ProductModel();

  ProductModel.full({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });
}
