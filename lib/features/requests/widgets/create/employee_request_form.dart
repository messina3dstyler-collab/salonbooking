import 'package:flutter/material.dart';

import '../../../shared/widgets/sheets/app_bottom_sheet.dart';

class EmployeeRequestForm extends StatefulWidget {
  const EmployeeRequestForm({
    super.key,
    required this.currentEmployee,
    required this.availableEmployees,
    required this.onConfirm,
  });

  final String currentEmployee;
  final List<String> availableEmployees;

  final void Function(
      String newEmployee,
      String? message,
      ) onConfirm;

  static Future<void> show(
      BuildContext context, {
        required String currentEmployee,
        required List<String> availableEmployees,
        required void Function(
            String newEmployee,
            String? message,
            )
        onConfirm,
      }) {
    return AppBottomSheet.show(
      context,
      title: "Cambio operatore",
      subtitle: "Proponi un nuovo operatore",
      showCloseButton: true,
      child: EmployeeRequestForm(
        currentEmployee: currentEmployee,
        availableEmployees: availableEmployees,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<EmployeeRequestForm> createState() =>
      _EmployeeRequestFormState();
}

class _EmployeeRequestFormState
    extends State<EmployeeRequestForm> {
  late String _selectedEmployee;

  final _messageController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedEmployee =
    widget.availableEmployees.isEmpty
        ? ""
        : widget.availableEmployees.first;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Operatore attuale"),
          subtitle: Text(widget.currentEmployee),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          initialValue: _selectedEmployee,
          decoration: const InputDecoration(
            labelText: "Nuovo operatore",
            border: OutlineInputBorder(),
          ),
          items: widget.availableEmployees
              .map(
                (employee) => DropdownMenuItem(
              value: employee,
              child: Text(employee),
            ),
          )
              .toList(),
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              _selectedEmployee = value;
            });
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _messageController,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: "Messaggio (facoltativo)",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          icon: const Icon(Icons.send),
          label: const Text("Crea richiesta"),
          onPressed: _selectedEmployee.isEmpty
              ? null
              : () {
            widget.onConfirm(
              _selectedEmployee,
              _messageController.text.trim().isEmpty
                  ? null
                  : _messageController.text.trim(),
            );

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}