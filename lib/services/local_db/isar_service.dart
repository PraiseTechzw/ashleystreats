import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/cart/data/cart_item_model.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  late Future<Isar> db;

  factory IsarService() {
    return _instance;
  }

  IsarService._internal() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([CartItemModelSchema], directory: dir.path);
  }

  Future<List<CartItemModel>> getCartItems() async {
    final isar = await db;
    return await isar.cartItemModels.where().findAll();
  }

  Future<void> addToCart(CartItemModel item) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cartItemModels.put(item);
    });
  }

  Future<void> removeFromCart(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cartItemModels.delete(id);
    });
  }

  Future<void> clearCart() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cartItemModels.clear();
    });
  }
}
