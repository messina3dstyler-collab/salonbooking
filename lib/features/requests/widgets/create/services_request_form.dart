import 'package:flutter/material.dart';

import '../../../shared/widgets/sheets/app_bottom_sheet.dart';

class ServicesRequestForm extends StatefulWidget {
  const ServicesRequestForm({
    super.key,
    required this.currentServices,
    required this.availableServices,
    required this.onConfirm,
  });

  final List<String> currentServices;
  final List<String> availableServices;

  final void Function(
      List<String> services,
      String? message,
      ) onConfirm;

  static Future<void> show(
      BuildContext context, {
        required List<String> currentServices,
        required List<String> availableServices,
        required void Function(
            List<String> services,
            String? message,
            )
        onConfirm,
      }) {
    return AppBottomSheet.show(
      context,
      title: "Cambio servizi",
      subtitle: "Seleziona i nuovi servizi",
      showCloseButton: true,
      child: ServicesRequestForm(
        currentServices: currentServices,
        availableServices: availableServices,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<ServicesRequestForm> createState() =>
      _ServicesRequestFormState();
}

class _ServicesRequestFormState
    extends State<ServicesRequestForm> {
  late final Set<String> _selected;

  final _messageController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    _selected = {
      ...widget.currentServices,
    };
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _toggle(String service) {
    setState(() {
      if (_selected.contains(service)) {
        _selected.remove(service);
      } else {
        _selected.add(service);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Servizi disponibili",
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),
        ),

        const SizedBox(height: 12),

        ...widget.availableServices.map(
              (service) {
            final selected =
            _selected.contains(service);

            return CheckboxListTile(
              value: selected,
              title: Text(service),
              controlAffinity:
              ListTileControlAffinity.leading,
              onChanged: (_) => _toggle(service),
            );
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
          onPressed: _selected.isEmpty
              ? null
              : () {
            widget.onConfirm(
              _selected.toList(),
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