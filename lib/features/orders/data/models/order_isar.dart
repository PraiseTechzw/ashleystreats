import 'package:isar/isar.dart';

part 'order_isar.g.dart';

@Collection()
class OrderIsar {
  Id id = Isar.autoIncrement;
  late List<int> productIds; // Store product IDs in the order
  late List<int> quantities; // Parallel list to productIds
  late double total;
  late String status; // e.g., Pending, Preparing, Delivered
  late DateTime createdAt;
  late String deliveryAddress;
  late String phoneNumber;
  late String deliveryTime; // Store as string for simplicity
}
