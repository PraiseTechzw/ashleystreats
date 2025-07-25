import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../local_db/isar_service.dart';
import '../../features/products/data/product_model.dart';
import '../../features/orders/data/order_model.dart';
import '../../features/orders/data/order_item_embedded.dart';

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();
  late Client client;
  late Account account;
  late Databases database;
  late Storage storage;

  // TODO: Set your Appwrite endpoint and project ID
  static const String endpoint = 'https://YOUR_APPWRITE_ENDPOINT/v1';
  static const String projectId = 'YOUR_PROJECT_ID';
  static const String dbId = 'YOUR_DATABASE_ID';
  static const String productsCollectionId = 'PRODUCTS_COLLECTION_ID';
  static const String ordersCollectionId = 'ORDERS_COLLECTION_ID';
  static const String usersCollectionId = 'USERS_COLLECTION_ID';
  static const String bucketId = 'YOUR_BUCKET_ID';

  factory AppwriteService() {
    return _instance;
  }

  AppwriteService._internal() {
    client = Client()
      ..setEndpoint(endpoint)
      ..setProject(projectId);
    account = Account(client);
    database = Databases(client);
    storage = Storage(client);
  }

  // --- AUTH ---
  Future<models.User?> getUser() async {
    try {
      return await account.get();
    } catch (_) {
      return null;
    }
  }

  Future<models.Session?> login(String email, String password) async {
    return await account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
  }

  Future<models.User> signUp(String email, String password, String name) async {
    return await account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }

  // --- PRODUCTS ---
  Future<void> createProduct(Map<String, dynamic> data) async {
    // TODO: Implement product creation
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final docs = await database.listDocuments(
      databaseId: dbId,
      collectionId: productsCollectionId,
    );
    return docs.documents.map((doc) => doc.data).toList();
    // TODO: Map to ProductModel and sync with Isar
  }

  Future<void> updateProduct(String docId, Map<String, dynamic> data) async {
    // TODO: Implement product update
  }

  Future<void> deleteProduct(String docId) async {
    // TODO: Implement product delete
  }

  Future<List<ProductModel>> syncProductsWithIsar() async {
    final docs = await database.listDocuments(
      databaseId: dbId,
      collectionId: productsCollectionId,
    );
    final products = docs.documents.map((doc) {
      final data = doc.data;
      return ProductModel.full(
        id: 0, // Isar will auto-increment
        name: data['name'] ?? '',
        price: (data['price'] is num) ? (data['price'] as num).toDouble() : 0.0,
        description: data['description'] ?? '',
        image: data['image'] ?? '',
      );
    }).toList();
    final isar = IsarService();
    // Clear local products and insert new ones
    final localProducts = await isar.getProducts();
    for (final p in localProducts) {
      await isar.deleteProduct(p.id);
    }
    for (final p in products) {
      await isar.addProduct(p);
    }
    return products;
  }

  // --- ORDERS ---
  Future<void> createOrder(Map<String, dynamic> data) async {
    await database.createDocument(
      databaseId: dbId,
      collectionId: ordersCollectionId,
      documentId: ID.unique(),
      data: data,
    );
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final docs = await database.listDocuments(
      databaseId: dbId,
      collectionId: ordersCollectionId,
    );
    return docs.documents.map((doc) => doc.data).toList();
  }

  Future<List<OrderModel>> syncOrdersWithIsar() async {
    final docs = await database.listDocuments(
      databaseId: dbId,
      collectionId: ordersCollectionId,
    );
    final orders = docs.documents.map((doc) {
      final data = doc.data;
      return OrderModel.full(
        id: 0, // Isar will auto-increment
        items: (data['items'] as List<dynamic>? ?? [])
            .map(
              (item) => OrderItemEmbedded.full(
                productId: item['productId'] ?? '',
                name: item['name'] ?? '',
                price: (item['price'] is num)
                    ? (item['price'] as num).toDouble()
                    : 0.0,
                quantity: item['quantity'] ?? 1,
                image: item['image'] ?? '',
              ),
            )
            .toList(),
        total: (data['total'] is num) ? (data['total'] as num).toDouble() : 0.0,
        address: data['address'] ?? '',
        phone: data['phone'] ?? '',
        deliveryTime: data['deliveryTime'] ?? '',
        status: data['status'] ?? 'Pending',
        createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      );
    }).toList();
    final isar = IsarService();
    // Clear local orders and insert new ones
    final localOrders = await isar.getOrders();
    for (final o in localOrders) {
      await isar.deleteProduct(o.id); // Should be deleteOrder, add if missing
    }
    for (final o in orders) {
      await isar.addOrder(o);
    }
    return orders;
  }

  // --- IMAGE UPLOAD ---
  Future<String> uploadImage(String filePath) async {
    // TODO: Implement image upload
    return '';
  }
}
