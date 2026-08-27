import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class SalonInfoSection extends StatelessWidget {
  const SalonInfoSection({
    super.key,
    required this.salonNameController,
    required this.ownerNameController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.descriptionController,
  });

  final TextEditingController salonNameController;
  final TextEditingController ownerNameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController descriptionController;

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
          controller: salonNameController,
          label: 'Nome salone',
          prefixIcon: const Icon(Icons.storefront_outlined),
          validator: _required,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          controller: ownerNameController,
          label: 'Nome titolare',
          prefixIcon: const Icon(Icons.person_outline),
          validator: _required,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          controller: phoneController,
          label: 'Telefono',
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.phone_outlined),
          validator: _required,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          controller: addressController,
          label: 'Indirizzo',
          prefixIcon: const Icon(Icons.location_on_outlined),
          validator: _required,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          controller: cityController,
          label: 'Città',
          prefixIcon: const Icon(Icons.location_city_outlined),
          validator: _required,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          controller: descriptionController,
          label: 'Descrizione',
          prefixIcon: const Icon(Icons.description_outlined),
          maxLines: 3,
        ),
      ],
    );
  }
}