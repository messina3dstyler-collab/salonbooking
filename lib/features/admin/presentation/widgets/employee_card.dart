import 'package:flutter/material.dart';

import 'package:salon_booking/features/employee/models/employee_model.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.employee,
    this.onTap,
    this.onCalendar,
    this.onDelete,
    this.onRestore,
  });

  final EmployeeModel employee;

  final VoidCallback? onTap;

  final VoidCallback? onCalendar;

  final VoidCallback? onDelete;

  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: employee.photoUrl.isNotEmpty
                    ? NetworkImage(
                  employee.photoUrl,
                )
                    : null,
                child: employee.photoUrl.isEmpty
                    ? const Icon(
                  Icons.person,
                  size: 30,
                )
                    : null,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          employee.active
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: employee.active
                              ? Colors.green
                              : Colors.red,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    if (employee.specialization.isNotEmpty)
                      Text(
                        employee.specialization,
                        style: TextStyle(
                          color:
                          Colors.grey.shade700,
                        ),
                      ),
                    if (employee.phone.isNotEmpty)
                      Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 4,
                        ),
                        child: Text(
                          employee.phone,
                          style: TextStyle(
                            color:
                            Colors.grey.shade600,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 6,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${employee.rating.toStringAsFixed(1)} (${employee.reviewCount})',
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [

                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: onCalendar,
                                icon: const Icon(Icons.calendar_month, size: 18),
                                label: const Text('Agenda'),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(42),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: onTap,
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Modifica'),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(42),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Azioni',

                onSelected: (value) {

                  switch (value) {

                    case 'delete':
                      onDelete?.call();
                      break;

                    case 'restore':
                      onRestore?.call();
                      break;

                  }

                },

                itemBuilder: (_) => [

                  if (employee.active)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [

                          Icon(Icons.block),

                          SizedBox(width: 8),

                          Text('Disattiva'),

                        ],
                      ),
                    ),

                  if (!employee.active)
                    const PopupMenuItem(
                      value: 'restore',
                      child: Row(
                        children: [

                          Icon(Icons.restore),

                          SizedBox(width: 8),

                          Text('Riattiva'),

                        ],
                      ),
                    ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}