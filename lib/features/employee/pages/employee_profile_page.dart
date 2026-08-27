import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';
import '../../review/review_providers.dart';
import '../../review/widgets/review_card.dart';
import '../../salon/models/salon_model.dart';
import '../../service/models/service_model.dart';
import 'package:salon_booking/features/employee/models/employee_model.dart';

import '../../service/presentation/pages/salon_services_page.dart';

class EmployeeProfilePage extends ConsumerStatefulWidget {
  const EmployeeProfilePage({
    super.key,
    required this.employee,
    required this.salon,
    required this.service,
  });

  final EmployeeModel employee;
  final SalonModel salon;
  final ServiceModel service;

  @override
  ConsumerState<EmployeeProfilePage> createState() =>
      _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends ConsumerState<EmployeeProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reviewControllerProvider).loadEmployeeReviews(
        salonId: widget.salon.id,
        employeeId: widget.employee.id,
      );
    });
  }

  void booking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SalonServicesPage(
          salon: widget.salon,
          selectedEmployee: widget.employee,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(reviewControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.employee.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 55,
              backgroundImage: widget.employee.photoUrl.isEmpty
                  ? null
                  : NetworkImage(widget.employee.photoUrl),
              child: widget.employee.photoUrl.isEmpty
                  ? Text(
                widget.employee.name.isEmpty
                    ? '?'
                    : widget.employee.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              widget.employee.name,
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              widget.employee.specialization,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Chip(
              avatar: Icon(
                widget.employee.active
                    ? Icons.check_circle
                    : Icons.cancel,
                color: widget.employee.active
                    ? Colors.green
                    : Colors.red,
                size: 18,
              ),
              label: Text(
                widget.employee.active
                    ? 'Disponibile'
                    : 'Non disponibile',
              ),
            ),
          ),
          const SizedBox(height: 22),

          SizedBox(
            height: 110,
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.star,
                    color: Colors.amber,
                    value: c.averageRating.toStringAsFixed(1),
                    label: 'Valutazione',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.rate_review,
                    color: Colors.blue,
                    value: '${c.reviewCount}',
                    label: 'Recensioni',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.workspace_premium,
                    color: Colors.green,
                    value: widget.employee.specialization.isEmpty
                        ? 'Staff'
                        : widget.employee.specialization,
                    label: 'Ruolo',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: widget.employee.active ? booking : null,
              icon: const Icon(Icons.calendar_month),
              label: const Text(
                'Prenota appuntamento',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 12),

          Text(
            'Recensioni',
            style: AppTextStyles.titleLarge,
          ),

          const SizedBox(height: 14),

          if (c.isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (c.reviews.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    'Questo operatore non ha ancora recensioni.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            ...c.reviews.map((e) => ReviewCard(review: e)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 26,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}