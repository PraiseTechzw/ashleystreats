import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/services/data_seeding_service.dart';
import 'providers/onboarding_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _textAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textAnimationController.forward();

    // Initialize sample data while animations are running
    try {
      await DataSeedingService().seedSampleData();
    } catch (e) {
      print('Error seeding data: $e');
    }

    // Wait for animations and then navigate
    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) {
      final hasSeenOnboarding = ref.read(onboardingProvider);
      if (hasSeenOnboarding) {
        Navigator.of(context).pushReplacementNamed('/auth');
      } else {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

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
              AppColors.cardColor.withOpacity(0.4),
              AppColors.primary.withOpacity(0.1),
              AppColors.background,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie Cupcake Animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 80,
                            offset: const Offset(0, 40),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Lottie.asset(
                          'assets/animations/cupcakeani.json',
                          fit: BoxFit.contain,
                          repeat: true,
                          animate: true,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // App title with slide animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Ashley\'s',
                          style: AppTheme.girlishHeadingStyle.copyWith(
                            fontSize: 48,
                            color: AppColors.primary,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Text(
                          'Treats',
                          style: AppTheme.girlishHeadingStyle.copyWith(
                            fontSize: 48,
                            color: AppColors.secondary,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tagline
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Text(
                    'Where Sweet Dreams Come True',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 18,
                      color: AppColors.secondary.withOpacity(0.8),
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Loading indicator with Lottie
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: LoadingWidget(
                    type: LoadingType.loading,
                    size: 40,
                    message: 'Loading...',
                    showMessage: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
