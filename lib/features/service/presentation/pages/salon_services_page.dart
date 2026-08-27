import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';
import '../../../employee/models/employee_model.dart';
import '../../../employee/pages/employees_page.dart';
import '../../../booking/presentation/pages/booking_page.dart';
import '../../../salon/models/salon_model.dart';
import '../../models/service_model.dart';
import '../../service_providers.dart';

class SalonServicesPage extends ConsumerStatefulWidget {
  const SalonServicesPage({
    super.key,
    required this.salon,
    this.selectedEmployee,
  });

  final SalonModel salon;
  final EmployeeModel? selectedEmployee;

  @override
  ConsumerState<SalonServicesPage> createState() =>
      _SalonServicesPageState();
}

class _SalonServicesPageState
    extends ConsumerState<SalonServicesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_loadServices);
  }

  Future<void> _loadServices() async {
    await ref
        .read(serviceControllerProvider)
        .loadServices(widget.salon.id);
  }

  void _openService(ServiceModel service) {
    if (widget.selectedEmployee != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingPage(
            salon: widget.salon,
            service: service,
            employee: widget.selectedEmployee!,
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeesPage(
          salonId: widget.salon.id,
          salon: widget.salon,
          service: service,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(serviceControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.salon.name),
      ),
      body: RefreshIndicator(
        onRefresh: _loadServices,
        child: controller.isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : controller.services.isEmpty
            ? const Center(
          child: Text(
            'Nessun servizio disponibile',
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.xl),
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final service = controller.services[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  service.name,
                  style: AppTextStyles.titleSmall,
                ),
                subtitle: Text(
                  '${service.description}\n${service.duration} min',
                ),
                trailing: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Text(
                      '€ ${service.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.selectedEmployee != null)
                      const Text(
                        'Prenota',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
                onTap: () => _openService(service),
              ),
            );
          },
        ),
      ),
    );
  }
}