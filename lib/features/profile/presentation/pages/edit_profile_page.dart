import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';
import '../../../home/home_providers.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    final user = ref.read(homeControllerProvider).user;

    nameController = TextEditingController(text: user?.name ?? '');

    phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();

    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(title: const Text("Modifica profilo")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              TextFormField(
                controller: nameController,

                decoration: const InputDecoration(
                  labelText: "Nome",

                  prefixIcon: Icon(Icons.person),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Inserisci il nome";
                  }

                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              TextFormField(
                controller: phoneController,

                keyboardType: TextInputType.phone,

                decoration: const InputDecoration(
                  labelText: "Telefono",

                  prefixIcon: Icon(Icons.phone),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),

                  label: const Text("Salva modifiche"),

                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final messenger = ScaffoldMessenger.of(context);

                    final navigator = Navigator.of(context);

                    await ref
                        .read(homeControllerProvider)
                        .updateProfile(
                          name: nameController.text.trim(),

                          phone: phoneController.text.trim(),
                        );

                    if (!mounted) {
                      return;
                    }

                    messenger.showSnackBar(
                      const SnackBar(content: Text("Profilo aggiornato")),
                    );

                    navigator.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
