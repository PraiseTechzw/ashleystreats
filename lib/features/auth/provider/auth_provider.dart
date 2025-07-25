import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/appwrite/appwrite_service.dart';
import 'package:appwrite/models.dart' as models;

class AuthState {
  final bool loading;
  final models.User? user;
  final String? error;
  final String? role;
  const AuthState({this.loading = false, this.user, this.error, this.role});

  AuthState copyWith({bool? loading, models.User? user, String? error, String? role}) {
    return AuthState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error,
      role: role ?? this.role,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AppwriteService _appwrite = AppwriteService();
  AuthNotifier() : super(const AuthState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    state = state.copyWith(loading: true);
    final user = await _appwrite.getUser();
    final role = _extractRole(user);
    state = state.copyWith(loading: false, user: user, role: role);
  }

  String _extractRole(models.User? user) {
    if (user == null) return 'customer';
    // Try to get role from user prefs or custom attribute
    try {
      final prefs = user.prefs.data;
      if (prefs != null && prefs['role'] != null) {
        return prefs['role'] as String;
      }
    } catch (_) {}
    return 'customer';
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _appwrite.login(email, password);
      final user = await _appwrite.getUser();
      final role = _extractRole(user);
      state = state.copyWith(loading: false, user: user, role: role);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _appwrite.signUp(email, password, name);
      await login(email, password);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _appwrite.logout();
      state = state.copyWith(loading: false, user: null, role: null);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
