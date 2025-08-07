import 'package:isar/isar.dart';

part 'order_isar.g.dart';

@Collection()
class OrderIsar {
  Id id = Isar.autoIncrement;
  late String orderId;
  late String userId;
  late String customerName;
  late String customerEmail;
  late String customerPhone;
  late List<dynamic> items; // Store order items as a list of maps
  late double totalAmount;
  late String status; // e.g., pending, confirmed, preparing, delivered, cancelled
  late String deliveryAddress;
  late String paymentMethod;
  late String specialInstructions;
  late DateTime orderDate;
  late DateTime estimatedDeliveryDate;
}
