import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_routes.dart';
import '../../../../app/theme/theme.dart';

import '../widgets/login_header.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(
                AppSpacing.xl,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),

                  const LoginHeader(),

                  const SizedBox(
                    height: AppSpacing.xxl,
                  ),

                  const RegisterForm(),

                  const SizedBox(
                    height: AppSpacing.xl,
                  ),

                  TextButton(
                    onPressed: () {
                      context.go(
                        AppRoutes.login,
                      );
                    },
                    child: Text(
                      'Hai già un account? Accedi',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
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