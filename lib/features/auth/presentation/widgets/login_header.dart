import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final logoSize = screenWidth * 0.75;

    return Column(
      children: [
        SizedBox(
          width: screenWidth,
          child: Center(
            child: AppLogo(
              size: logoSize.clamp(
                260,
                420,
              ),
            ),
          ),
        ),

        const SizedBox(
          height: AppSpacing.xl,
        ),

        Text(
          'Benvenuto',
          style: AppTextStyles.titleLarge,
        ),

        const SizedBox(
          height: AppSpacing.sm,
        ),

        Text(
          'Accedi al tuo account SalonBooking',
          textAlign: TextAlign.center,
          style: AppTextStyles.body,
        ),
      ],
    );
  }
}