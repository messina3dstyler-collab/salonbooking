import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class SalonAccountSection extends StatelessWidget {
  const SalonAccountSection({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onPasswordVisibilityChanged,
    required this.onConfirmPasswordVisibilityChanged,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool obscurePassword;
  final bool obscureConfirmPassword;

  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onConfirmPasswordVisibilityChanged;

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obbligatorio';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(
            Icons.email_outlined,
          ),
          validator: _required,
        ),

        const SizedBox(
          height: AppSpacing.lg,
        ),

        AppTextField(
          controller: passwordController,
          label: 'Password',
          obscureText: obscurePassword,
          prefixIcon: const Icon(
            Icons.lock_outline,
          ),
          validator: (value) {
            final result = _required(value);

            if (result != null) {
              return result;
            }

            if (value!.length < 6) {
              return 'Minimo 6 caratteri';
            }

            return null;
          },
          suffixIcon: IconButton(
            onPressed: onPasswordVisibilityChanged,
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
          ),
        ),

        const SizedBox(
          height: AppSpacing.lg,
        ),

        AppTextField(
          controller: confirmPasswordController,
          label: 'Conferma password',
          obscureText: obscureConfirmPassword,
          prefixIcon: const Icon(
            Icons.lock_outline,
          ),
          validator: (value) {
            final result = _required(value);

            if (result != null) {
              return result;
            }

            if (value != passwordController.text) {
              return 'Le password non coincidono';
            }

            return null;
          },
          suffixIcon: IconButton(
            onPressed: onConfirmPasswordVisibilityChanged,
            icon: Icon(
              obscureConfirmPassword
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
          ),
        ),
      ],
    );
  }
}