import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';
import '../../auth_providers.dart';
import 'salon_account_section.dart';
import 'salon_closed_days_section.dart';
import 'salon_info_section.dart';
import 'salon_opening_hours_section.dart';
import 'salon_register_button.dart';

class SalonRegisterForm extends ConsumerStatefulWidget {
  const SalonRegisterForm({super.key});

  @override
  ConsumerState<SalonRegisterForm> createState() =>
      _SalonRegisterFormState();
}

class _SalonRegisterFormState extends ConsumerState<SalonRegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final salonNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  int openingHour = 9;
  int closingHour = 19;

  final List<int> closedWeekdays = [];

  @override
  void dispose() {
    salonNameController.dispose();
    ownerNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = ref.read(salonRegisterControllerProvider);

    final success = await controller.register(
      ownerName: ownerNameController.text.trim(),
      salonName: salonNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      description: descriptionController.text.trim(),
      openingHour: openingHour,
      closingHour: closingHour,
      closedWeekdays: closedWeekdays,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.errorMessage ?? 'Errore registrazione salone',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Salone creato con successo'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(salonRegisterControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          SalonInfoSection(
            salonNameController: salonNameController,
            ownerNameController: ownerNameController,
            phoneController: phoneController,
            addressController: addressController,
            cityController: cityController,
            descriptionController: descriptionController,
          ),
          const SizedBox(height: AppSpacing.xl),
          SalonAccountSection(
            emailController: emailController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            obscurePassword: obscurePassword,
            obscureConfirmPassword: obscureConfirmPassword,
            onPasswordVisibilityChanged: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            onConfirmPasswordVisibilityChanged: () {
              setState(() {
                obscureConfirmPassword = !obscureConfirmPassword;
              });
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          SalonOpeningHoursSection(
            openingHour: openingHour,
            closingHour: closingHour,
            onOpeningChanged: (value) {
              setState(() {
                openingHour = value;
                if (closingHour <= value) {
                  closingHour = value + 1;
                }
              });
            },
            onClosingChanged: (value) {
              setState(() {
                closingHour = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          SalonClosedDaysSection(
            closedWeekdays: closedWeekdays,
            onChanged: (days) {
              setState(() {
                closedWeekdays
                  ..clear()
                  ..addAll(days);
              });
            },
          ),
          const SizedBox(height: AppSpacing.xxl),
          SalonRegisterButton(
            isLoading: controller.isLoading,
            onPressed: controller.isLoading ? null : _register,
          ),
        ],
      ),
    );
  }
}