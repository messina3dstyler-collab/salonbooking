import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/theme/theme.dart';
import '../../../../../core/animations/animations.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../controller/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashController _controller;

  @override
  void initState() {
    super.initState();

    _controller = const SplashController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await _controller.initialize();

      if (!mounted) return;

      context.go(
        result.route,
        extra: result.extra,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeAnimation(
                  child: ScaleAnimation(
                    child: const AppLogo(size: 170),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const AnimatedLoadingDots(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}