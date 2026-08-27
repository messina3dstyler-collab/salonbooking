import 'package:flutter/material.dart';

import '../../../shared/widgets/sheets/app_bottom_sheet.dart';

class CustomRequestForm extends StatefulWidget {
  const CustomRequestForm({
    super.key,
    required this.onConfirm,
  });

  final void Function(
      String title,
      String message,
      ) onConfirm;

  static Future<void> show(
      BuildContext context, {
        required void Function(
            String title,
            String message,
            ) onConfirm,
      }) {
    return AppBottomSheet.show(
      context,
      title: "Richiesta personalizzata",
      subtitle: "Scrivi un messaggio libero",
      showCloseButton: true,
      child: CustomRequestForm(
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<CustomRequestForm> createState() =>
      _CustomRequestFormState();
}

class _CustomRequestFormState
    extends State<CustomRequestForm> {
  final _titleController =
  TextEditingController();

  final _messageController =
  TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: "Titolo",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: _messageController,
          minLines: 5,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: "Messaggio",
            border: OutlineInputBorder(),
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
              _titleController.text.trim(),
              _messageController.text.trim(),
            );

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}