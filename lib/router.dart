import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'features/splash/presentation/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Onboarding'),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Login'),
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Register'),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Home'),
        );
      case AppRoutes.productDetail:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Product Detail'),
        );
      case AppRoutes.cart:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Cart'),
        );
      case AppRoutes.checkout:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Checkout'),
        );
      case AppRoutes.orderConfirmation:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Order Confirmation'),
        );
      case AppRoutes.orderTracking:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Order Tracking'),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Profile'),
        );
      case AppRoutes.pastOrders:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Past Orders'),
        );
      case AppRoutes.adminLogin:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Admin Login'),
        );
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderWidget('Admin Dashboard'),
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
