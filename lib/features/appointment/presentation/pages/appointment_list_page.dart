import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';
import '../../appointment_providers.dart';
import '../../controller/appointment_controller.dart';
import '../widgets/appointment_card.dart';

class AppointmentListPage extends ConsumerStatefulWidget {
  const AppointmentListPage({
    super.key,
  });

  @override
  ConsumerState<AppointmentListPage> createState() =>
      _AppointmentListPageState();
}

class _AppointmentListPageState
    extends ConsumerState<AppointmentListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(appointmentControllerProvider)
          .loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      appointmentControllerProvider,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'I miei appuntamenti',
        ),
      ),
      body: _body(controller),
    );
  }

  Widget _body(
      AppointmentController controller,
      ) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.error != null) {
      return Center(
        child: Text(
          controller.error!,
        ),
      );
    }

    if (controller.appointments.isEmpty) {
      return const Center(
        child: Text(
          'Nessun appuntamento trovato',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return ref
            .read(appointmentControllerProvider)
            .loadAppointments();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        itemCount: controller.appointments.length,
        itemBuilder: (context, index) {
          return AppointmentCard(
            appointment: controller.appointments[index],
          );
        },
      ),
    );
  }
}