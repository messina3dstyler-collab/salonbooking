import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../auth_providers.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(registerControllerProvider);

    final success = await controller.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.errorMessage ?? 'Errore durante la registrazione',
          ),
        ),
      );
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obbligatorio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(registerControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: _nameController,
            label: 'Nome',
            hint: 'Mario Rossi',
            prefixIcon: const Icon(Icons.person_outline),
            validator: _required,
          ),

          const SizedBox(height: AppSpacing.lg),

          AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'nome@email.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
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
            controller: _phoneController,
            label: 'Telefono',
            hint: '3331234567',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: _required,
          ),

          const SizedBox(height: AppSpacing.lg),

          AppTextField(
            controller: _passwordController,
            label: 'Password',
            obscureText: _obscurePassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Inserisci la password';
              }

              if (value.length < 6) {
                return 'Minimo 6 caratteri';
              }

              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          AppTextField(
            controller: _confirmPasswordController,
            label: 'Conferma password',
            obscureText: _obscureConfirmPassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword =
                  !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Conferma la password';
              }

              if (value != _passwordController.text) {
                return 'Le password non coincidono';
              }

              return null;
            },
          ),

          const SizedBox(height: AppSpacing.xxl),

          PrimaryButton(
            text: 'Crea account',
            isLoading: controller.isLoading,
            onPressed: controller.isLoading ? null : _register,
          ),
        ],
      ),
    );
  }
}