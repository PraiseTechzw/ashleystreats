import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/error/app_error.dart';
import 'services/isar/isar_service.dart';
import 'services/firebase/firebase_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/splash/presentation/onboarding_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    final error = ErrorHandler.handleError(details.exception, details.stack);
    ErrorHandler.logError(error);
  };

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    // Initialize Firebase if enabled
    if (AppConfig.useFirebaseAuth || AppConfig.useFirestore || AppConfig.useFirebaseMessaging) {
      await FirebaseService().init();
    }
    
    // Initialize Isar database if enabled
    if (AppConfig.useIsarDatabase) {
      await IsarService().isar;
    }
  } catch (e, stack) {
    final error = ErrorHandler.handleError(e, stack);
    ErrorHandler.logError(error);
  }

  runApp(const ProviderScope(child: AshleyTreatsApp()));
}

class AshleyTreatsApp extends ConsumerWidget {
  const AshleyTreatsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: !AppConfig.isDebugMode,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/auth': (context) => const AuthWrapper(),
      },
      onGenerateRoute: (settings) {
        // Handle dynamic routing if needed
        switch (settings.name) {
          default:
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );
        }
      },
      builder: (context, child) {
        // Global error boundary and app wrapper
        return ErrorBoundary(
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

// Global error boundary widget
class ErrorBoundary extends StatelessWidget {
  final Widget child;

  const ErrorBoundary({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
