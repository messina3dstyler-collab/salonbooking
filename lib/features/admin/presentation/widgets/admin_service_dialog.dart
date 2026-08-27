import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../admin_providers.dart';
import '../../models/admin_service_model.dart';

class AdminServiceDialog extends ConsumerStatefulWidget {
  const AdminServiceDialog({
    super.key,
    required this.salonId,
    this.service,
  });

  final String salonId;
  final AdminServiceModel? service;

  bool get isEditing => service != null;

  @override
  ConsumerState<AdminServiceDialog> createState() =>
      _AdminServiceDialogState();
}

class _AdminServiceDialogState
    extends ConsumerState<AdminServiceDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late TextEditingController _priceController;

  String _category = 'Altro';

  bool _active = true;
  bool _saving = false;

  final List<String> _categories = [
    'Taglio',
    'Colore',
    'Barba',
    'Trattamento',
    'Piega',
    'Altro',
  ];

  @override
  void initState() {
    super.initState();

    final service = widget.service;

    _nameController = TextEditingController(
      text: service?.name ?? '',
    );

    _descriptionController = TextEditingController(
      text: service?.description ?? '',
    );

    _durationController = TextEditingController(
      text: service == null
          ? ''
          : service.duration.toString(),
    );

    _priceController = TextEditingController(
      text: service == null
          ? ''
          : service.price.toStringAsFixed(2),
    );

    _category = _categories.contains(service?.category)
        ? service!.category
        : 'Altro';

    _active = service?.active ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isEditing
            ? 'Modifica servizio'
            : 'Nuovo servizio',
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome servizio',
                    prefixIcon: Icon(
                      Icons.content_cut,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Inserisci il nome';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    prefixIcon: Icon(
                      Icons.category,
                    ),
                  ),
                  items: _categories
                      .map(
                        (category) =>
                            DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _category = value;
                    });
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    prefixIcon: Icon(
                      Icons.description,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Durata minuti',
                    prefixIcon: Icon(
                      Icons.timer,
                    ),
                  ),
                  validator: (value) {
                    final duration =
                        int.tryParse(value ?? '');

                    if (duration == null ||
                        duration <= 0) {
                      return 'Durata non valida';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Prezzo',
                    prefixIcon: Icon(
                      Icons.euro,
                    ),
                  ),
                  validator: (value) {
                    final price = double.tryParse(
                      (value ?? '')
                          .replaceAll(',', '.'),
                    );

                    if (price == null ||
                        price < 0) {
                      return 'Prezzo non valido';
                    }

                    return null;
                  },
                ),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Servizio attivo',
                  ),
                  value: _active,
                  onChanged: (value) {
                    setState(() {
                      _active = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: const Text(
            'Annulla',
          ),
        ),
        ElevatedButton(
          onPressed: _saving
              ? null
              : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Salva',
                ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final controller = ref.read(
      adminServicesControllerProvider,
    );

    try {
      final duration = int.tryParse(
            _durationController.text.trim(),
          ) ??
          0;

      final price = double.tryParse(
            _priceController.text
                .trim()
                .replaceAll(',', '.'),
          ) ??
          0;

      final data = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _category,
        'duration': duration,
        'price': price,
        'active': _active,
      };

      if (widget.isEditing) {
        await controller.updateService(
          serviceId: widget.service!.id,
          data: data,
        );
      } else {
        await controller.createService(
          AdminServiceModel(
            id: '',
            name: data['name'] as String,
            description: data['description'] as String,
            category: data['category'] as String,
            duration: data['duration'] as int,
            price: data['price'] as double,
            active: data['active'] as bool,
          ),
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Errore salvataggio servizio: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }
}