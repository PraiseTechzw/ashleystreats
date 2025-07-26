import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'services/isar/isar_service.dart';
import 'services/firebase/firebase_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/logout_button.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/splash/presentation/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase and FCM
  await FirebaseService().init();
  // Initialize Isar (singleton, lazy)
  await IsarService().isar;
  runApp(const ProviderScope(child: AshleyTreatsApp()));
}

class AshleyTreatsApp extends ConsumerWidget {
  const AshleyTreatsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Ashley\'s Treats',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const PlaceholderHomeScreen(),
        '/auth': (context) => const AuthWrapper(),
      },
    );
  }
}

class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ashley\'s Treats'),
        actions: const [LogoutButton()],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.cardColor.withOpacity(0.3),
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Icon(Icons.cake, size: 80, color: AppColors.primary),
              ),
              const SizedBox(height: 32),
              Text(
                'Welcome to Ashley\'s Treats!',
                style: AppTheme.girlishHeadingStyle,
              ),
              const SizedBox(height: 16),
              Text(
                'Your delicious treats are just a click away',
                style: AppTheme.elegantBodyStyle,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate to products or main features
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Coming Soon! 🎂',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          color: AppColors.onSecondary,
                        ),
                      ),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: Text('Explore Treats', style: AppTheme.buttonTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
