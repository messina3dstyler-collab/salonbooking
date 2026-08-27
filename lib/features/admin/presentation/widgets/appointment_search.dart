import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

class AppointmentSearch extends StatefulWidget {
  const AppointmentSearch({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  State<AppointmentSearch> createState() =>
      _AppointmentSearchState();
}

class _AppointmentSearchState
    extends State<AppointmentSearch> {

  final TextEditingController _controller =
  TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: _controller,

      onChanged: (value) {
        setState(() {});
        widget.onChanged(value);
      },

      decoration: InputDecoration(

        hintText: "Cerca cliente...",

        prefixIcon: const Icon(
          Icons.search,
        ),

        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
          icon: const Icon(
            Icons.clear,
          ),
          onPressed: _clearSearch,
        ),

        filled: true,

        fillColor: Colors.white,

        contentPadding:
        const EdgeInsets.symmetric(
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.lg,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.lg,
          ),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.lg,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}