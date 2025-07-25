import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/appwrite/appwrite_service.dart';
import 'package:appwrite/models.dart' as models;

class AuthState {
  final bool loading;
  final models.User? user;
  final String? error;
  const AuthState({this.loading = false, this.user, this.error});

  AuthState copyWith({bool? loading, models.User? user, String? error}) {
    return AuthState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error,
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
    state = state.copyWith(loading: false, user: user);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _appwrite.login(email, password);
      final user = await _appwrite.getUser();
      state = state.copyWith(loading: false, user: user);
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
      state = state.copyWith(loading: false, user: null);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
