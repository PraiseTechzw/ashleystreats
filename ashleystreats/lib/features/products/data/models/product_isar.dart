import 'package:isar/isar.dart';
part 'product_isar.g.dart';

@Collection()
class ProductIsar {
  Id id = Isar.autoIncrement;
  late String name;
  late String description;
  late double price;
  late String imageUrl;
  // Add more fields as needed
}
