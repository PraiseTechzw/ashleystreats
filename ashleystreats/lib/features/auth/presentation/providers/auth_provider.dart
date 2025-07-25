import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl();
});

class AuthState extends StateNotifier<UserEntity?> {
  final AuthRepositoryImpl repository;
  AuthState(this.repository) : super(null);

  Future<void> login(String email, String password) async {
    state = await repository.login(email: email, password: password);
  }

  Future<void> register(
    String email,
    String password,
    String displayName,
    String phoneNumber,
  ) async {
    state = await repository.register(
      email: email,
      password: password,
      displayName: displayName,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> logout() async {
    await repository.logout();
    state = null;
  }

  Future<void> loadCurrentUser() async {
    state = await repository.getCurrentUser();
  }
}

final authStateProvider = StateNotifierProvider<AuthState, UserEntity?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthState(repo);
});
