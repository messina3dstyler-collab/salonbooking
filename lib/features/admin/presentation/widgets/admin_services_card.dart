import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../../models/admin_service_model.dart';

class AdminServicesCard extends StatelessWidget {
  const AdminServicesCard({
    super.key,
    required this.service,
    required this.onTap,
    required this.onDelete,
    required this.onRestore,
  });

  final AdminServiceModel service;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _statusColor.withValues(
                  alpha: 0.15,
                ),
                child: Icon(
                  Icons.content_cut,
                  color: _statusColor,
                ),
              ),
              const SizedBox(
                width: AppSpacing.md,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name.isEmpty
                                ? 'Servizio'
                                : service.name,
                            style: AppTextStyles.titleMedium,
                          ),
                        ),
                        _StatusBadge(
                          active: service.active,
                        ),
                      ],
                    ),
                    if (service.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 6,
                        ),
                        child: Text(
                          service.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          service.formattedDuration,
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        const Icon(
                          Icons.euro_outlined,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          service.formattedPrice,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Azioni servizio',
                padding: EdgeInsets.zero,
                itemBuilder: (_) {
                  if (service.active) {
                    return const [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.block),
                            SizedBox(width: 8),
                            Text('Disattiva'),
                          ],
                        ),
                      ),
                    ];
                  }

                  return const [
                    PopupMenuItem(
                      value: 'restore',
                      child: Row(
                        children: [
                          Icon(Icons.restore),
                          SizedBox(width: 8),
                          Text('Riattiva'),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete();
                  }

                  if (value == 'restore') {
                    onRestore();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color get _statusColor =>
      service.active ? Colors.green : Colors.red;
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.active,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.15,
        ),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Text(
        active ? 'ATTIVO' : 'DISATTIVO',
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}