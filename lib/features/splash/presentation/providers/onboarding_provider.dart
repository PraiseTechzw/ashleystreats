import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadOnboardingStatus();
  }

  static const String _onboardingKey = 'has_seen_onboarding';

  Future<void> _loadOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool(_onboardingKey) ?? false;
      state = hasSeenOnboarding;
    } catch (e) {
      // If there's an error, default to showing onboarding
      state = false;
    }
  }

  Future<void> markOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
      state = true;
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, false);
      state = false;
    } catch (e) {
      // Handle error silently
    }
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((
  ref,
) {
  return OnboardingNotifier();
});

final hasSeenOnboardingProvider = Provider<bool>((ref) {
  return ref.watch(onboardingProvider);
});
