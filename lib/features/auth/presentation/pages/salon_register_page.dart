import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../widgets/salon_register_form.dart';
import '../widgets/salon_register_header.dart';

class SalonRegisterPage extends StatelessWidget {
  const SalonRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: const [
                  SizedBox(height: AppSpacing.xl),
                  SalonRegisterHeader(),
                  SizedBox(height: AppSpacing.xxl),
                  SalonRegisterForm(),
                  SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}