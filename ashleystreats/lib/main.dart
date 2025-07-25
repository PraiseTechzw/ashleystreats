import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';
import 'services/isar/isar_service.dart';
import 'services/firebase/firebase_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/logout_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase and FCM
  await FirebaseService().init();
  // Initialize Isar (singleton, lazy)
  await IsarService().isar;
  runApp(const ProviderScope(child: PurpleCrumbsApp()));
}

class PurpleCrumbsApp extends ConsumerWidget {
  const PurpleCrumbsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Purple Crumbs by Ash',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.accent,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.onSecondary,
          onSurface: AppColors.secondary,
          onBackground: AppColors.secondary,
          onError: AppColors.surface,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.cardColor,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.playfairDisplay(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          displaySmall: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
          headlineSmall: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
          titleLarge: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.secondary,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.secondary,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.secondary,
          ),
          labelLarge: GoogleFonts.dancingScript(
            fontSize: 18,
            color: AppColors.accent,
          ),
        ),
        useMaterial3: true,
      ),
      home: AuthGate(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const PlaceholderHomeScreen(),
      },
    );
  }
}

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(authStateProvider.notifier).loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future,
      builder: (context, snapshot) {
        final user = ref.watch(authStateProvider);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (user != null) {
          return const PlaceholderHomeScreen();
        } else {
          return const LoginScreen();
        }
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
        title: Text(
          'Purple Crumbs by Ash',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: const [LogoutButton()],
      ),
      body: Center(
        child: Text(
          'Welcome to Purple Crumbs by Ash!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
