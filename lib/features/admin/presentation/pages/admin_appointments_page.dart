import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../admin_providers.dart';
import '../../controllers/admin_appointments_controller.dart';
import '../widgets/appointment_admin_card.dart';
import '../widgets/appointment_filter_bar.dart';
import '../widgets/empty_state.dart';

class AdminAppointmentsPage extends ConsumerStatefulWidget {
  const AdminAppointmentsPage({super.key});

  @override
  ConsumerState<AdminAppointmentsPage> createState() =>
      _AdminAppointmentsPageState();
}

class _AdminAppointmentsPageState
    extends ConsumerState<AdminAppointmentsPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadAppointments);
  }

  Future<void> _loadAppointments() async {
    final salonId = ref.read(adminCurrentSalonProvider);

    debugPrint("SALON ID = $salonId");

    if (salonId.isEmpty) return;

    await ref
        .read(adminAppointmentsControllerProvider)
        .loadAppointments(
      salonId: salonId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller =
    ref.watch(adminAppointmentsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestione Appuntamenti',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAppointments,
        child: Column(
          children: [
            AppointmentFilterBar(
              selectedFilter: controller.filter,
              employees: controller.employeesMap,
              selectedEmployeeId:
              controller.selectedEmployeeId,
              searchQuery:
              controller.searchQuery,
              onSearchChanged:
              controller.changeSearch,
              onFilterChanged:
              controller.changeFilter,
              onEmployeeChanged:
              controller.changeEmployeeFilter,
              onReset:
              controller.clearFilters,
            ),
            Expanded(
              child: _buildContent(
                controller,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      AdminAppointmentsController controller,
      ) {

    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            controller.error!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (controller.appointments.isEmpty) {
      return const EmptyState(
        message: 'Nessun appuntamento trovato',
        icon: Icons.calendar_month,
      );
    }

    return ListView.builder(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.all(16),
      itemCount:
      controller.appointments.length,
      itemBuilder:
          (context, index) {

        final appointment =
        controller.appointments[index];

        return Padding(
          padding:
          const EdgeInsets.only(bottom: 12),
          child: AppointmentAdminCard(
            appointment: appointment,
            onStatusChanged: (status) {
              ref
                  .read(
                adminAppointmentsControllerProvider,
              )
                  .updateStatus(
                appointmentId:
                appointment.id,
                status:
                status,
              );
            },
          ),
        );
      },
    );
  }
}