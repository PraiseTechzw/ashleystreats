import 'package:appwrite/appwrite.dart';
import 'dart:typed_data';

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();
  late final Client client;
  late final Storage storage;

  // Media bucket ID constant
  static const String mediaBucketId = '6883864f0033c9aa544c';

  factory AppwriteService() {
    return _instance;
  }

  AppwriteService._internal() {
    client = Client()
      ..setEndpoint('https://6883449200037fa86c79.appwrite.global/v1')
      ..setProject('6883449200037fa86c79');
    storage = Storage(client);
  }

  Future<void> uploadFile({
    String bucketId = mediaBucketId,
    required String filePath,
    required String fileId,
  }) async {
    try {
      await storage.createFile(
        bucketId: bucketId,
        fileId: fileId,
        file: InputFile.fromPath(path: filePath),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List?> downloadFile({
    String bucketId = mediaBucketId,
    required String fileId,
  }) async {
    try {
      final result = await storage.getFileDownload(
        bucketId: bucketId,
        fileId: fileId,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
