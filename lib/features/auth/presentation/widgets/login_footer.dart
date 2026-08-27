import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_routes.dart';
import '../../../../app/theme/theme.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // TODO: Password dimenticata
          },
          child: Text(
            'Password dimenticata?',
            style: AppTextStyles.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Non hai un account?',
              style: AppTextStyles.body,
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.register),
              child: Text(
                'Cliente',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sei un professionista?',
              style: AppTextStyles.body,
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.salonRegister),
              child: Text(
                'Registra il tuo salone',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}