import 'package:flutter/material.dart';

import '../../../shared/widgets/sheets/app_bottom_sheet.dart';

class CancelRequestForm extends StatefulWidget {
  const CancelRequestForm({
    super.key,
    required this.onConfirm,
  });

  final void Function(
      String reason,
      ) onConfirm;

  static Future<void> show(
      BuildContext context, {
        required void Function(
            String reason,
            ) onConfirm,
      }) {
    return AppBottomSheet.show(
      context,
      title: "Annullamento appuntamento",
      subtitle: "Invia una richiesta di annullamento",
      showCloseButton: true,
      child: CancelRequestForm(
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<CancelRequestForm> createState() =>
      _CancelRequestFormState();
}

class _CancelRequestFormState
    extends State<CancelRequestForm> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.cancel_outlined,
          size: 56,
          color: Colors.red,
        ),

        const SizedBox(height: 20),

        const Text(
          "Motivo dell'annullamento",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 18),

        TextField(
          controller: _controller,
          minLines: 4,
          maxLines: 6,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Inserisci il motivo...",
          ),
        ),

        const SizedBox(height: 28),

        FilledButton.icon(
          icon: const Icon(Icons.send),
          label: const Text(
            "Invia richiesta",
          ),
          onPressed: () {
            widget.onConfirm(
              _controller.text.trim(),
            );

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}