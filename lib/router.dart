import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/splash/presentation/onboarding_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/products/presentation/product_list_screen.dart';
import 'features/cart/presentation/cart_screen.dart';
import 'features/cart/presentation/checkout_screen.dart';
import 'features/orders/presentation/order_confirmation_screen.dart';
import 'features/orders/presentation/order_history_screen.dart';
import 'features/orders/presentation/order_tracking_screen.dart';
import 'features/orders/presentation/admin_orders_dashboard_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const ProductListScreen());
      case AppRoutes.productDetail:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Product Detail'),
        );
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case AppRoutes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case AppRoutes.orderConfirmation:
        return MaterialPageRoute(
          builder: (_) => const OrderConfirmationScreen(),
        );
      case AppRoutes.orderTracking:
        return MaterialPageRoute(builder: (_) => const OrderTrackingScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Profile'),
        );
      case AppRoutes.pastOrders:
        return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());
      case AppRoutes.adminLogin:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Admin Login'),
        );
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminOrdersDashboardScreen(),
        );
      case AppRoutes.adminProductEdit:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Admin Product Edit'),
        );
      case AppRoutes.adminOrderDetail:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Admin Order Detail'),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Unknown Route'),
        );
    }
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;
  const PlaceholderWidget(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title screen.')),
    );
  }
}
