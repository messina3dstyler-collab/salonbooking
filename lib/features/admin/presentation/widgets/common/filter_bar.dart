import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';


class FilterBar<T> extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.filters,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });


  /// Lista elementi filtro
  final List<T> filters;


  /// Filtro attivo
  final T selected;


  /// Come visualizzare il testo
  final String Function(T item) labelBuilder;


  /// Cambio filtro
  final ValueChanged<T> onSelected;



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection:
        Axis.horizontal,


        itemCount:
        filters.length,


        separatorBuilder:
            (_, _) =>
        const SizedBox(
          width: AppSpacing.sm,
        ),


        itemBuilder:
            (context, index) {

          final item =
          filters[index];


          final isSelected =
              item == selected;


          return ChoiceChip(
            label:
            Text(
              labelBuilder(item),
            ),


            selected:
            isSelected,


            onSelected:
                (_) =>
                onSelected(item),


            labelStyle:
            AppTextStyles
                .labelMedium
                .copyWith(
              fontWeight:
              FontWeight.w600,
            ),


            selectedColor:
            AppColors.primary
                .withValues(
              alpha: 0.15,
            ),


            backgroundColor:
            AppColors.surface,


            side:
            BorderSide(
              color:
              isSelected
                  ? AppColors.primary
                  : Colors.grey.shade300,
            ),


            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                AppRadius.lg,
              ),
            ),
          );
        },
      ),
    );
  }
}