import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';

import '../../../employee/employee_providers.dart';
import '../../../employee/models/employee_model.dart';
import '../../../employee/pages/employee_profile_page.dart';

import '../../../review/review_providers.dart';
import '../../../review/widgets/review_card.dart';

import '../../models/salon_model.dart';

import '../../../service/models/service_model.dart';
import '../../../service/service_providers.dart';
import '../../../service/presentation/pages/salon_services_page.dart';

class SalonDetailPage extends ConsumerStatefulWidget {
  const SalonDetailPage({
    super.key,
    required this.salon,
  });

  final SalonModel salon;

  @override
  ConsumerState<SalonDetailPage> createState() =>
      _SalonDetailPageState();
}

class _SalonDetailPageState
    extends ConsumerState<SalonDetailPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {

      await ref
          .read(serviceControllerProvider)
          .loadServices(widget.salon.id);

      await ref
          .read(employeeControllerProvider)
          .loadEmployees(widget.salon.id);

      await ref
          .read(reviewControllerProvider)
          .loadReviews(
            salonId: widget.salon.id,
          );
    });
  }

  void _booking() {

    final services =
        ref.read(serviceControllerProvider).services;

    if (services.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SalonServicesPage(
          salon: widget.salon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final serviceController =
        ref.watch(serviceControllerProvider);

    final employeeController =
        ref.watch(employeeControllerProvider);

    final reviewController =
        ref.watch(reviewControllerProvider);

    final services = serviceController.services;

    final employees = employeeController.employees;

    final reviews = reviewController.reviews;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: CustomScrollView(

        slivers: [

          SliverAppBar(

            expandedHeight: 280,

            pinned: true,

            elevation: 0,

            backgroundColor: Colors.white,

            flexibleSpace: FlexibleSpaceBar(

              background: Stack(

                fit: StackFit.expand,

                children: [

                  widget.salon.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.salon.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.store,
                            size: 90,
                          ),
                        ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: .70),
                        ],
                      ),
                    ),
                  ),

                  Positioned(

                    left: 20,
                    right: 20,
                    bottom: 28,

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(

                          widget.salon.name,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(

                          children: [

                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),

                            const SizedBox(width: 6),

                            Text(

                              widget.salon.rating
                                  .toStringAsFixed(1),

                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 8),

                            Text(

                              "(${widget.salon.reviewCount} recensioni)",

                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(

                          children: [

                            const Icon(
                              Icons.location_on,
                              size: 18,
                              color: Colors.white70,
                            ),

                            const SizedBox(width: 6),

                            Expanded(

                              child: Text(

                                "${widget.salon.address}, ${widget.salon.city}",

                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(

            child: Padding(

              padding: const EdgeInsets.all(20),

              child: Column(

                children: [
                  Row(

                    children: [

                      Expanded(
                        child: _StatCard(
                          icon: Icons.star_rounded,
                          color: Colors.amber,
                          value: widget.salon.rating
                              .toStringAsFixed(1),
                          label: "Valutazione",
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _StatCard(
                          icon: Icons.people_alt_rounded,
                          color: Colors.blue,
                          value:
                              "${employeeController.employeeCount}",
                          label: "Operatori",
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _StatCard(
                          icon: Icons.content_cut_rounded,
                          color: Colors.green,
                          value: "${services.length}",
                          label: "Servizi",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Row(

                    children: [

                      Expanded(

                        child: FilledButton.icon(

                          onPressed: _booking,

                          icon: const Icon(
                            Icons.calendar_month,
                          ),

                          label: const Text(
                            "Prenota",
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      IconButton.filled(

                        onPressed: () {},

                        icon: const Icon(
                          Icons.phone,
                        ),
                      ),

                      const SizedBox(width: 10),

                      IconButton.filled(

                        onPressed: () {},

                        icon: const Icon(
                          Icons.location_on,
                        ),
                      ),

                      const SizedBox(width: 10),

                      IconButton.filled(

                        onPressed: () {},

                        icon: const Icon(
                          Icons.share,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Align(

                    alignment: Alignment.centerLeft,

                    child: Text(

                      "Chi siamo",

                      style: AppTextStyles.titleLarge,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(

                    elevation: 0,

                    child: Padding(

                      padding: const EdgeInsets.all(18),

                      child: Text(

                        widget.salon.description.isEmpty
                            ? "Nessuna descrizione disponibile."
                            : widget.salon.description,

                        style: AppTextStyles.body,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Align(

                    alignment: Alignment.centerLeft,

                    child: Text(

                      "Operatori",

                      style: AppTextStyles.titleLarge,
                    ),
                  ),

                  const SizedBox(height: 14),
                  if (employeeController.isLoading)

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )

                  else if (employees.isEmpty)

                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            "Nessun operatore disponibile.",
                          ),
                        ),
                      ),
                    )

                  else

                    SizedBox(

                      height: 255,

                      child: ListView.separated(

                        scrollDirection: Axis.horizontal,

                        itemCount: employees.length,

                        separatorBuilder: (_, _) =>
                            const SizedBox(width: 14),

                        itemBuilder: (_, i) {

                          final EmployeeModel employee =
                              employees[i];

                          return SizedBox(

                            width: 185,

                            child: InkWell(

                              borderRadius:
                                  BorderRadius.circular(18),

                              onTap: () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>
                                        EmployeeProfilePage(

                                      employee: employee,

                                      salon: widget.salon,

                                      service: services.isEmpty
                                          ? const ServiceModel(
                                              id: '',
                                              name: '',
                                              description: '',
                                              duration: 0,
                                              price: 0,
                                            )
                                          : services.first,
                                    ),
                                  ),
                                );
                              },

                              child: Card(

                                child: Padding(

                                  padding:
                                      const EdgeInsets.all(16),

                                  child: Column(

                                    children: [

                                      CircleAvatar(

                                        radius: 38,

                                        backgroundImage:
                                            employee.photoUrl.isEmpty
                                                ? null
                                                : NetworkImage(
                                                    employee.photoUrl,
                                                  ),

                                        child:
                                            employee.photoUrl.isEmpty
                                                ? Text(
                                                    employee.name
                                                            .isEmpty
                                                        ? '?'
                                                        : employee
                                                            .name[0]
                                                            .toUpperCase(),
                                                  )
                                                : null,
                                      ),

                                      const SizedBox(height: 14),

                                      Text(

                                        employee.name,

                                        maxLines: 2,

                                        overflow:
                                            TextOverflow.ellipsis,

                                        textAlign: TextAlign.center,

                                        style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(

                                        employee.specialization,

                                        maxLines: 2,

                                        overflow:
                                            TextOverflow.ellipsis,

                                        textAlign: TextAlign.center,

                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const Spacer(),

                                      Row(

                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: [

                                          const Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.amber,
                                          ),

                                          const SizedBox(width: 4),

                                          Text(
                                            employee.rating
                                                .toStringAsFixed(1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 30),

                  Align(

                    alignment: Alignment.centerLeft,

                    child: Text(
                      "Servizi",
                      style: AppTextStyles.titleLarge,
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (serviceController.isLoading)

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )

                  else if (services.isEmpty)

                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            "Nessun servizio disponibile.",
                          ),
                        ),
                      ),
                    )

                  else

                    ...services.map(

                      (service) => Card(

                        child: ListTile(

                          leading: const CircleAvatar(
                            child: Icon(Icons.content_cut),
                          ),

                          title: Text(service.name),

                          subtitle: Text(
                            "${service.duration} min",
                          ),

                          trailing: Text(
                            "€ ${service.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  Align(

                    alignment: Alignment.centerLeft,

                    child: Text(
                      "Recensioni",
                      style: AppTextStyles.titleLarge,
                    ),
                  ),

                  const SizedBox(height: 14),
                  if (reviewController.isLoading)

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )

                  else if (reviews.isEmpty)

                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child: Text(
                            "Questo salone non ha ancora recensioni.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )

                  else

                    ...reviews.map(
                      (review) => ReviewCard(
                        review: review,
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
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
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 10,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: .12),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}