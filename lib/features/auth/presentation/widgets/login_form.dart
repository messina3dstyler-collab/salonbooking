import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../auth_providers.dart';

// <<< AGGIUNGI QUESTO IMPORT >>>
import '../../../admin/providers/current_salon_provider.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = ref.read(loginControllerProvider);

    final success = await controller.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.errorMessage ?? 'Errore durante il login',
          ),
        ),
      );
      return;
    }

    if (controller.isAdmin) {
      final salonId = controller.currentSalonId;

      if (salonId == null || salonId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Salone non associato all\'account.',
            ),
          ),
        );
        return;
      }

      // ==========================================
      // SALVA IL SALONE NEL PROVIDER
      // ==========================================
      ref.read(currentSalonIdProvider.notifier).state = salonId;

      debugPrint("CURRENT SALON PROVIDER = $salonId");

      context.go(
        AppRoutes.adminHome,
        extra: salonId,
      );

      return;
    }

    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(loginControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: emailController,
            label: 'Email',
            hint: 'Inserisci la tua email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Inserisci l\'email';
              }

              if (!value.contains('@')) {
                return 'Email non valida';
              }

              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: passwordController,
            label: 'Password',
            obscureText: obscurePassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Inserisci la password';
              }

              if (value.length < 6) {
                return 'La password deve contenere almeno 6 caratteri';
              }

              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            text: 'Accedi',
            isLoading: controller.isLoading,
            onPressed: controller.isLoading ? null : _login,
          ),
        ],
      ),
    );
  }
}