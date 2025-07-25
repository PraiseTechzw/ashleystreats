import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';
import 'core/constants/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/provider/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    if (authState.loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    final initialRoute = authState.user == null
        ? AppRoutes.login
        : AppRoutes.home;
    return MaterialApp(
      title: 'Purple Crumbs',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
