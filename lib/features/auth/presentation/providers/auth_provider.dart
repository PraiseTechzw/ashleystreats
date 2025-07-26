import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl();
});

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final UserEntity? user;
  final AuthStatus status;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.user,
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    UserEntity? user,
    AuthStatus? status,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;
  bool get isAdmin => user?.role == 'admin';
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl repository;

  AuthNotifier(this.repository) : super(const AuthState()) {
    // Load current user on initialization
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    try {
      state = state.copyWith(status: AuthStatus.loading, isLoading: true);
      final user = await repository.getCurrentUser();

      if (user != null) {
        state = state.copyWith(
          user: user,
          status: AuthStatus.authenticated,
          isLoading: false,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          errorMessage: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        isLoading: false,
        errorMessage: 'Failed to load user: ${e.toString()}',
      );
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(
        status: AuthStatus.loading,
        isLoading: true,
        errorMessage: null,
      );

      final user = await repository.login(email: email, password: password);

      if (user != null) {
        state = state.copyWith(
          user: user,
          status: AuthStatus.authenticated,
          isLoading: false,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          isLoading: false,
          errorMessage: 'Login failed. Please try again.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> register(
    String email,
    String password,
    String displayName,
    String phoneNumber,
  ) async {
    try {
      state = state.copyWith(
        status: AuthStatus.loading,
        isLoading: true,
        errorMessage: null,
      );

      final user = await repository.register(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );

      if (user != null) {
        state = state.copyWith(
          user: user,
          status: AuthStatus.authenticated,
          isLoading: false,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          isLoading: false,
          errorMessage: 'Registration failed. Please try again.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        isLoading: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(status: AuthStatus.loading, isLoading: true);

      await repository.logout();

      state = state.copyWith(
        user: null,
        status: AuthStatus.unauthenticated,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        isLoading: false,
        errorMessage: 'Logout failed: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void updateUser(UserEntity user) {
    state = state.copyWith(user: user);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

// Convenience providers
final authUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authStateProvider).user;
});

final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authStateProvider).status;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAdmin;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).errorMessage;
});
