import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/appointment_filter.dart';

class AppointmentFilterBar extends StatefulWidget {
  const AppointmentFilterBar({
    super.key,
    required this.selectedFilter,
    required this.employees,
    required this.selectedEmployeeId,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onEmployeeChanged,
    required this.onReset,
  });

  final AppointmentFilter selectedFilter;
  final Map<String, String> employees;
  final String? selectedEmployeeId;
  final String searchQuery;

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<AppointmentFilter> onFilterChanged;
  final ValueChanged<String?> onEmployeeChanged;
  final VoidCallback onReset;

  @override
  State<AppointmentFilterBar> createState() =>
      _AppointmentFilterBarState();
}

class _AppointmentFilterBarState
    extends State<AppointmentFilterBar> {

  late final TextEditingController _searchController;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(
      text: widget.searchQuery,
    );

    _searchController.addListener(
          () {
        setState(() {});
      },
    );
  }

  @override
  void didUpdateWidget(
      AppointmentFilterBar oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchQuery != widget.searchQuery &&
        _searchController.text != widget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  void _onSearchChanged(
      String value,
      ) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(
        milliseconds: 300,
      ),
          () {
        widget.onSearchChanged(
          value,
        );
      },
    );
  }

  void _clearSearch() {
    _searchController.clear();

    widget.onSearchChanged('');
  }

  void _resetFilters() {
    _debounce?.cancel();

    _searchController.clear();

    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              labelText:
              'Cerca appuntamento',

              hintText:
              'Cliente, telefono, servizio, dipendente...',

              border:
              const OutlineInputBorder(),

              prefixIcon:
              const Icon(
                Icons.search,
              ),

              suffixIcon:
              _searchController.text.isEmpty
                  ? null
                  : IconButton(
                icon:
                const Icon(
                  Icons.clear,
                ),
                onPressed:
                _clearSearch,
              ),
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          DropdownButtonFormField<AppointmentFilter>(
            initialValue:
            widget.selectedFilter,

            decoration:
            const InputDecoration(
              labelText:
              'Stato',

              border:
              OutlineInputBorder(),

              prefixIcon:
              Icon(
                Icons.filter_alt,
              ),
            ),

            items:
            AppointmentFilter.values
                .map(
                  (
                  filter,
                  ) {
                return DropdownMenuItem<
                    AppointmentFilter>(
                  value:
                  filter,
                  child:
                  Text(
                    filter.label,
                  ),
                );
              },
            )
                .toList(),

            onChanged:
                (
                value,
                ) {
              if (value == null) {
                return;
              }

              widget.onFilterChanged(
                value,
              );
            },
          ),

          const SizedBox(
            height: 12,
          ),

          DropdownButtonFormField<String>(
            initialValue:
            widget.selectedEmployeeId,

            decoration:
            const InputDecoration(
              labelText:
              'Dipendente',

              border:
              OutlineInputBorder(),

              prefixIcon:
              Icon(
                Icons.person,
              ),
            ),

            items: [
              const DropdownMenuItem<String>(
                value: null,
                child:
                Text(
                  'Tutti i dipendenti',
                ),
              ),

              ...widget.employees.entries.map(
                    (
                    entry,
                    ) {
                  return DropdownMenuItem<String>(
                    value:
                    entry.key,
                    child:
                    Text(
                      entry.value,
                    ),
                  );
                },
              ),
            ],

            onChanged:
            widget.onEmployeeChanged,
          ),

          Align(
            alignment:
            Alignment.centerRight,

            child:
            TextButton.icon(
              onPressed:
              _resetFilters,

              icon:
              const Icon(
                Icons.clear,
              ),

              label:
              const Text(
                'Reset filtri',
              ),
            ),
          ),
        ],
      ),
    );
  }
}