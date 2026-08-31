import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';
import '../../appointment_providers.dart';
import '../../controller/appointment_controller.dart';
import '../widgets/appointment_card.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({
    super.key,
  });

  @override
  ConsumerState<AppointmentsPage> createState() =>
      _AppointmentsPageState();
}

class _AppointmentsPageState
    extends ConsumerState<AppointmentsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(_load);
  }

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    await ref
        .read(appointmentControllerProvider)
        .loadAppointments();
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
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: [
            SizedBox(
              height:
              MediaQuery.of(context).size.height * 0.4,
              child: const Center(
                child: Text(
                  'Non hai ancora prenotazioni',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
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