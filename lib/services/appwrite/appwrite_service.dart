import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

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
    return await account.createEmailPasswordSession(email: email, password: password);
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
    // TODO: Implement product fetch
    return [];
  }

  Future<void> updateProduct(String docId, Map<String, dynamic> data) async {
    // TODO: Implement product update
  }

  Future<void> deleteProduct(String docId) async {
    // TODO: Implement product delete
  }

  // --- ORDERS ---
  Future<void> createOrder(Map<String, dynamic> data) async {
    // TODO: Implement order creation
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    // TODO: Implement order fetch
    return [];
  }

  // --- IMAGE UPLOAD ---
  Future<String> uploadImage(String filePath) async {
    // TODO: Implement image upload
    return '';
  }
} 