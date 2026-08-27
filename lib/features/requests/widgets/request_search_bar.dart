import 'package:flutter/material.dart';

class RequestSearchBar extends StatelessWidget {
  const RequestSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText = "Cerca cliente, richiesta...",
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        isDense: true,
      ),
    );
  }
}