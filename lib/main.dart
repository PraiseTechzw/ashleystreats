import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';
import 'core/constants/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/provider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    String initialRoute;
    if (authState.user == null || authState.user?.$id == null) {
      initialRoute = AppRoutes.login;
    } else {
      initialRoute = AppRoutes.home;
    }
    print('Building MaterialApp with initialRoute: $initialRoute');
    return MaterialApp(
      title: 'Purple Crumbs',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRoutes.register,
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Scaffold(
            body: Center(
              child: Text('Error: \n${details.exceptionAsString()}'),
            ),
          );
        };
        return child!;
      },
    );
  }
}
