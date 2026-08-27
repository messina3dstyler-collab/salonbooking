import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';


class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.onChanged,
    this.hintText = 'Cerca...',
    this.controller,
  });


  final ValueChanged<String> onChanged;

  final String hintText;

  final TextEditingController? controller;



  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      onChanged: onChanged,

      decoration: InputDecoration(
        hintText: hintText,

        prefixIcon: const Icon(
          Icons.search,
        ),

        suffixIcon:
        controller != null
            ? ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller!,
          builder: (
              context,
              value,
              child,
              ) {
            if (value.text.isEmpty) {
              return const SizedBox();
            }

            return IconButton(
              icon: const Icon(
                Icons.clear,
              ),
              onPressed: () {
                controller!.clear();
                onChanged('');
              },
            );
          },
        )
            : null,


        filled: true,

        fillColor:
        AppColors.surface,


        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppRadius.lg,
          ),

          borderSide:
          BorderSide.none,
        ),


        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppRadius.lg,
          ),

          borderSide:
          BorderSide.none,
        ),


        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            AppRadius.lg,
          ),

          borderSide:
          BorderSide(
            color:
            AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}