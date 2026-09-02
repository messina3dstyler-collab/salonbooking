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
  const SalonRegisterForm({
    super.key,
  });

  @override
  ConsumerState<SalonRegisterForm> createState() =>
      _SalonRegisterFormState();
}

class _SalonRegisterFormState
    extends ConsumerState<SalonRegisterForm> {
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
  final taxIdController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  String taxIdType = 'vat';

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
    taxIdController.dispose();

    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = ref.read(
      salonRegisterControllerProvider,
    );

    if (controller.isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await controller.register(
      ownerName: ownerNameController.text.trim(),
      salonName: salonNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      description: descriptionController.text.trim(),
      taxIdType: taxIdType,
      taxId: taxIdController.text.trim(),
      openingHour: openingHour,
      closingHour: closingHour,
      closedWeekdays: List<int>.from(closedWeekdays),
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.errorMessage ??
                'Errore durante la registrazione del salone.',
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Salone creato con successo.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      salonRegisterControllerProvider,
    );

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
          const SizedBox(
            height: AppSpacing.xl,
          ),
          _buildTaxIdSection(),
          const SizedBox(
            height: AppSpacing.xl,
          ),
          SalonAccountSection(
            emailController: emailController,
            passwordController: passwordController,
            confirmPasswordController:
            confirmPasswordController,
            obscurePassword: obscurePassword,
            obscureConfirmPassword:
            obscureConfirmPassword,
            onPasswordVisibilityChanged: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            onConfirmPasswordVisibilityChanged: () {
              setState(() {
                obscureConfirmPassword =
                !obscureConfirmPassword;
              });
            },
          ),
          const SizedBox(
            height: AppSpacing.xl,
          ),
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
          const SizedBox(
            height: AppSpacing.xl,
          ),
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
          const SizedBox(
            height: AppSpacing.xxl,
          ),
          SalonRegisterButton(
            isLoading: controller.isLoading,
            onPressed: controller.isLoading
                ? null
                : _register,
          ),
        ],
      ),
    );
  }

  Widget _buildTaxIdSection() {
    final isVat = taxIdType == 'vat';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dati fiscali',
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        DropdownButtonFormField<String>(
          initialValue: taxIdType,
          decoration: const InputDecoration(
            labelText: 'Tipo identificativo fiscale',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: 'vat',
              child: Text('Partita IVA'),
            ),
            DropdownMenuItem(
              value: 'fiscalCode',
              child: Text('Codice Fiscale'),
            ),
          ],
          onChanged: controllerIsLoading
              ? null
              : (value) {
            if (value == null) {
              return;
            }

            setState(() {
              taxIdType = value;
              taxIdController.clear();
            });
          },
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        TextFormField(
          controller: taxIdController,
          textCapitalization:
          TextCapitalization.characters,
          decoration: InputDecoration(
            labelText:
            isVat ? 'Partita IVA' : 'Codice Fiscale',
            hintText: isVat
                ? 'Inserisci la Partita IVA'
                : 'Inserisci il Codice Fiscale',
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            final text = value?.trim() ?? '';

            if (text.isEmpty) {
              return isVat
                  ? 'La Partita IVA è obbligatoria'
                  : 'Il Codice Fiscale è obbligatorio';
            }

            return null;
          },
        ),
      ],
    );
  }

  bool get controllerIsLoading {
    return ref.read(
      salonRegisterControllerProvider,
    ).isLoading;
  }
}