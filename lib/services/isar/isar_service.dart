import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../features/products/data/models/product_isar.dart';
import '../../features/cart/data/models/cart_item_isar.dart';
import '../../features/orders/data/models/order_isar.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  Isar? _isar;

  factory IsarService() {
    return _instance;
  }

  IsarService._internal();

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      ProductIsarSchema,
      CartItemIsarSchema,
      OrderIsarSchema,
      // Add more schemas as needed
    ], directory: dir.path);
    return _isar!;
  }
}
