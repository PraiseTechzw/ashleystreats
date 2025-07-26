import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final authStatus = authState.status;

    return switch (authStatus) {
      AuthStatus.initial => const AuthLoadingScreen(),
      AuthStatus.loading => const AuthLoadingScreen(),
      AuthStatus.authenticated => _buildAuthenticatedScreen(authState),
      AuthStatus.unauthenticated => const LoginScreen(),
      AuthStatus.error => _buildErrorScreen(context, ref, authState),
    };
  }

  Widget _buildAuthenticatedScreen(AuthState authState) {
    if (authState.user == null) {
      return const LoginScreen();
    }
    // Route based on user role - using placeholder for now
    if (authState.isAdmin) {
      return Scaffold(
        // Placeholder for AdminNavScreen
        appBar: AppBar(title: const Text('Admin Dashboard')),
        body: const Center(child: Text('Admin Dashboard - Coming Soon')),
      );
    } else {
      return Scaffold(
        // Placeholder for CustomerNavScreen
        appBar: AppBar(title: const Text('Customer Dashboard')),
        body: const Center(child: Text('Customer Dashboard - Coming Soon')),
      );
    }
  }

  Widget _buildErrorScreen(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
  ) {
    return Scaffold(
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
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 60,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Error Title
                  Text(
                    'Oops! Something went wrong',
                    style: AppTheme.girlishHeadingStyle.copyWith(
                      fontSize: 28,
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Error Message
                  Text(
                    authState.errorMessage ??
                        'An unexpected error occurred. Please try again.',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.secondary.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(authStateProvider.notifier).clearError();
                          },
                          child: Text(
                            'Try Again',
                            style: AppTheme.buttonTextStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(authStateProvider.notifier).clearError();
                            Navigator.of(
                              context,
                            ).pushReplacementNamed('/login');
                          },
                          child: Text(
                            'Go to Login',
                            style: AppTheme.buttonTextStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthLoadingScreen extends StatelessWidget {
  const AuthLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo with Lottie
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Lottie.asset(
                      'assets/animations/cupcakeani.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Loading Text
                Text(
                  'Ashley\'s Treats',
                  style: AppTheme.girlishHeadingStyle.copyWith(
                    fontSize: 32,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Loading Animation
                LoadingWidget(
                  type: LoadingType.loading,
                  size: 60,
                  message: 'Checking authentication...',
                  showMessage: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final bool requireAdmin;

  const AuthGuard({Key? key, required this.child, this.requireAdmin = false})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState.status == AuthStatus.loading) {
      return const AuthLoadingScreen();
    }

    if (!authState.isAuthenticated) {
      return _buildAccessDeniedScreen(context, 'Please log in to continue');
    }

    if (requireAdmin && !authState.isAdmin) {
      return _buildAccessDeniedScreen(context, 'Admin access required');
    }

    return child;
  }

  Widget _buildAccessDeniedScreen(BuildContext context, String message) {
    return Scaffold(
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
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Access Denied Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 60,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Access Denied Title
                  Text(
                    'Access Denied',
                    style: AppTheme.girlishHeadingStyle.copyWith(
                      fontSize: 28,
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Access Denied Message
                  Text(
                    message,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.secondary.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text(
                        'Go to Login',
                        style: AppTheme.buttonTextStyle.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
