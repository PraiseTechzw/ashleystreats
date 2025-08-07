class AppConfig {
  // App Information
  static const String appName = 'Ashley\'s Treats';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Delicious treats delivered to your doorstep';

  // Business Information
  static const String businessName = 'Ashley\'s Treats';
  static const String businessPhone = '+1 (555) 123-4567';
  static const String businessEmail = 'orders@ashleystreats.com';
  static const String businessAddress = '123 Sweet Street, New York, NY 10001';

  // Order Configuration
  static const int defaultDeliveryDays = 1;
  static const double minimumOrderAmount = 10.0;
  static const double deliveryFee = 5.0;
  static const double freeDeliveryThreshold = 50.0;

  // Payment Methods
  static const List<String> paymentMethods = [
    'Credit Card',
    'Debit Card',
    'PayPal',
    'Apple Pay',
    'Google Pay',
    'Cash on Delivery',
  ];

  // Order Status Options
  static const List<String> orderStatuses = [
    'pending',
    'confirmed',
    'preparing',
    'ready',
    'out_for_delivery',
    'delivered',
    'cancelled',
  ];

  static String getOrderStatusDisplayName(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready for Pickup';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  // Categories
  static const List<String> productCategories = [
    'Cupcakes',
    'Cake Slices',
    'Cake Tasters',
    'Cake Pops',
    'Custom Cakes',
    'Seasonal Specials',
  ];

  // Firebase Configuration
  static const bool useFirebaseAuth = true;
  static const bool useFirestore = true;
  static const bool useFirebaseMessaging = true;

  // Appwrite Configuration
  static const bool useAppwriteStorage = true;
  static const String appwriteEndpoint = 'https://6883449200037fa86c79.appwrite.global/v1';
  static const String appwriteProjectId = '6883449200037fa86c79';
  static const String appwriteStorageBucketId = '6883864f0033c9aa544c';

  // Local Storage Configuration
  static const bool useIsarDatabase = true;

  // Features
  static const bool enablePushNotifications = true;
  static const bool enableImageUpload = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = false; // Set to true in production

  // Debug Settings
  static const bool isDebugMode = true; // Set to false in production
  static const bool showDetailedErrors = true; // Set to false in production

  // API Configuration (if needed for external services)
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
}