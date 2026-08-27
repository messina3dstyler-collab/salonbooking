import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../admin_providers.dart';
import 'package:salon_booking/features/employee/models/employee_model.dart';

class EmployeeDialog extends ConsumerStatefulWidget {
  const EmployeeDialog({
    super.key,
    required this.salonId,
    this.employee,
  });

  final String salonId;
  final EmployeeModel? employee;

  bool get isEditing => employee != null;

  @override
  ConsumerState<EmployeeDialog> createState() =>
      _EmployeeDialogState();
}

class _EmployeeDialogState
    extends ConsumerState<EmployeeDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _photoController;
  late final TextEditingController _specializationController;

  bool _active = true;
  bool _saving = false;

  late TimeOfDay _startWork;
  late TimeOfDay _endWork;

  late TimeOfDay _breakStart;
  late TimeOfDay _breakEnd;

  @override
  void initState() {
    super.initState();

    final employee = widget.employee;

    _nameController = TextEditingController(
      text: employee?.name ?? '',
    );

    _phoneController = TextEditingController(
      text: employee?.phone ?? '',
    );

    _photoController = TextEditingController(
      text: employee?.photoUrl ?? '',
    );

    _specializationController =
        TextEditingController(
      text: employee?.specialization ?? '',
    );

    _active = employee?.active ?? true;

    _startWork = TimeOfDay(
      hour: employee?.startHour ?? 9,
      minute: 0,
    );

    _endWork = TimeOfDay(
      hour: employee?.endHour ?? 18,
      minute: 0,
    );

    final breakStart =
        employee?.breakStart ?? 13 * 60;

    final breakEnd =
        employee?.breakEnd ?? 14 * 60;

    _breakStart = TimeOfDay(
      hour: breakStart ~/ 60,
      minute: breakStart % 60,
    );

    _breakEnd = TimeOfDay(
      hour: breakEnd ~/ 60,
      minute: breakEnd % 60,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _photoController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  String _time(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime(
    TimeOfDay current,
    ValueChanged<TimeOfDay> onChanged,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
    );

    if (picked == null) return;

    setState(() {
      onChanged(picked);
    });
  }

  Widget _timeTile({
    required IconData icon,
    required String title,
    required TimeOfDay value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      trailing: FilledButton.tonal(
        onPressed: onTap,
        child: Text(_time(value)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isEditing
            ? 'Modifica dipendente'
            : 'Nuovo dipendente',
      ),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Inserisci il nome';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller:
                      _specializationController,
                  decoration: const InputDecoration(
                    labelText: 'Specializzazione',
                    prefixIcon: Icon(Icons.work),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _phoneController,
                  keyboardType:
                      TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefono',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _photoController,
                  decoration: const InputDecoration(
                    labelText: 'URL foto',
                    prefixIcon: Icon(Icons.image),
                  ),
                ),

                const SizedBox(height: 20),

                const Divider(),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Orario di lavoro',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _timeTile(
                  icon: Icons.login,
                  title: 'Inizio turno',
                  value: _startWork,
                  onTap: () => _pickTime(
                    _startWork,
                    (t) => _startWork = t,
                  ),
                ),

                _timeTile(
                  icon: Icons.logout,
                  title: 'Fine turno',
                  value: _endWork,
                  onTap: () => _pickTime(
                    _endWork,
                    (t) => _endWork = t,
                  ),
                ),

                const Divider(),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pausa pranzo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _timeTile(
                  icon: Icons.lunch_dining,
                  title: 'Inizio pausa',
                  value: _breakStart,
                  onTap: () => _pickTime(
                    _breakStart,
                    (t) => _breakStart = t,
                  ),
                ),

                _timeTile(
                  icon: Icons.restaurant,
                  title: 'Fine pausa',
                  value: _breakEnd,
                  onTap: () => _pickTime(
                    _breakEnd,
                    (t) => _breakEnd = t,
                  ),
                ),

                const SizedBox(height: 8),

                SwitchListTile(
                  contentPadding:
                      EdgeInsets.zero,
                  title: const Text(
                    'Dipendente attivo',
                  ),
                  value: _active,
                  onChanged: _saving
                      ? null
                      : (v) {
                          setState(() {
                            _active = v;
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
              : () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Salva'),
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

    try {
      final employee = EmployeeModel(
        id: widget.employee?.id ?? '',
        salonId: widget.salonId,

        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        photoUrl: _photoController.text.trim(),

        specialization:
            _specializationController.text.trim(),

        active: _active,

        rating:
            widget.employee?.rating ?? 0,

        reviewCount:
            widget.employee?.reviewCount ?? 0,

        workingDays:
            widget.employee?.workingDays ??
                const [1, 2, 3, 4, 5],

        startHour: _startWork.hour,
        endHour: _endWork.hour,

        breakStart:
            (_breakStart.hour * 60) +
                _breakStart.minute,

        breakEnd:
            (_breakEnd.hour * 60) +
                _breakEnd.minute,
      );

      final controller =
          ref.read(
        employeeControllerProvider,
      );

      if (widget.isEditing) {
        await controller.updateEmployee(
          employeeId: widget.employee!.id,
          data: employee.toMap(),
        );
      } else {
        await controller.createEmployee(
          employee,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Dipendente aggiornato'
                : 'Dipendente creato',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Errore salvataggio: $e',
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