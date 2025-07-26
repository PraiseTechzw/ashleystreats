import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  Future<void> init() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission();
    // Optionally configure FCM handlers here
  }
}
