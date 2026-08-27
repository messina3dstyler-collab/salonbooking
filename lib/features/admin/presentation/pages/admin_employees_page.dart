import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../admin_providers.dart';
import 'package:salon_booking/features/employee/models/employee_model.dart';

import '../../../employee/pages/employee_calendar_page.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_dialog.dart';

class AdminEmployeesPage extends ConsumerStatefulWidget {
  const AdminEmployeesPage({
    super.key,
  });

  @override
  ConsumerState<AdminEmployeesPage> createState() =>
      _AdminEmployeesPageState();
}

class _AdminEmployeesPageState
    extends ConsumerState<AdminEmployeesPage> {
  final TextEditingController _searchController =
  TextEditingController();

  String _filter = 'Tutti';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });

    Future.microtask(() {
      final salonId = ref.read(
        adminCurrentSalonProvider,
      );

      if (salonId.isEmpty) {
        return;
      }

      ref
          .read(
        employeeControllerProvider,
      )
          .loadAllEmployees(
        salonId,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EmployeeModel> _applyFilters(
      List<EmployeeModel> employees,
      ) {
    final query = _searchController.text
        .trim()
        .toLowerCase();

    return employees.where((employee) {
      final searchMatch =
          query.isEmpty ||
              employee.name
                  .toLowerCase()
                  .contains(query) ||
              employee.specialization
                  .toLowerCase()
                  .contains(query);

      final filterMatch = switch (_filter) {
        'Attivi' => employee.active,
        'Disattivi' => !employee.active,
        _ => true,
      };

      return searchMatch && filterMatch;
    }).toList();
  }

  Future<void> _openEmployeeDialog(
      EmployeeModel? employee,
      ) async {
    final salonId = ref.read(
      adminCurrentSalonProvider,
    );

    await showDialog(
      context: context,
      builder: (_) {
        return EmployeeDialog(
          salonId: salonId,
          employee: employee,
        );
      },
    );

    if (!mounted) {
      return;
    }

    await ref
        .read(
      employeeControllerProvider,
    )
        .refresh();
  }

  void _openCalendar(
      EmployeeModel employee,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeeCalendarPage(
          employee: employee,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      employeeControllerProvider,
    );

    final employees = _applyFilters(
      controller.employees,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dipendenti',
        ),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Nuovo',
        ),
        onPressed: () {
          _openEmployeeDialog(
            null,
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller:
                  _searchController,
                  decoration:
                  InputDecoration(
                    labelText:
                    'Cerca dipendente',
                    prefixIcon:
                    const Icon(
                      Icons.search,
                    ),
                    suffixIcon:
                    _searchController
                        .text
                        .isEmpty
                        ? null
                        : IconButton(
                      icon:
                      const Icon(
                        Icons.clear,
                      ),
                      onPressed:
                          () {
                        _searchController
                            .clear();
                      },
                    ),
                    border:
                    const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Tutti',
                      label: Text(
                        'Tutti',
                      ),
                    ),
                    ButtonSegment(
                      value: 'Attivi',
                      label: Text(
                        'Attivi',
                      ),
                    ),
                    ButtonSegment(
                      value: 'Disattivi',
                      label: Text(
                        'Disattivi',
                      ),
                    ),
                  ],
                  selected: {
                    _filter,
                  },
                  onSelectionChanged:
                      (value) {
                    setState(() {
                      _filter =
                          value.first;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(
                  employeeControllerProvider,
                )
                    .refresh();
              },
              child: _buildContent(
                controller,
                employees,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      dynamic controller,
      List<EmployeeModel> employees,
      ) {
    if (controller.isLoading) {
      return const Center(
        child:
        CircularProgressIndicator(),
      );
    }

    if (controller.error != null) {
      return Center(
        child: Text(
          controller.error!,
        ),
      );
    }

    if (employees.isEmpty) {
      return ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 250,
          ),
          Center(
            child: Text(
              'Nessun dipendente trovato',
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding:
      const EdgeInsets.all(16),
      itemCount: employees.length,
      itemBuilder: (
          context,
          index,
          ) {
        final employee =
        employees[index];

        return EmployeeCard(
          employee: employee,

          onTap: () {
            _openEmployeeDialog(
              employee,
            );
          },

          onCalendar: () {
            _openCalendar(
              employee,
            );
          },

          onDelete: () {
            _confirmDelete(
              employee,
            );
          },

          onRestore: () {
            _restoreEmployee(
              employee,
            );
          },
        );
      },
    );
  }

  Future<void> _restoreEmployee(
      EmployeeModel employee,
      ) async {
    await ref
        .read(
      employeeControllerProvider,
    )
        .restoreEmployee(
      employee.id,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Dipendente riattivato',
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
      EmployeeModel employee,
      ) async {
    final confirm =
    await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Disattivare dipendente?',
          ),
          content: Text(
            'Vuoi disattivare ${employee.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Annulla',
              ),
            ),
            ElevatedButton(
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.red,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Disattiva',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    await ref
        .read(
      employeeControllerProvider,
    )
        .deleteEmployee(
      employee.id,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Dipendente disattivato',
        ),
      ),
    );
  }
}