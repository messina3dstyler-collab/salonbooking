import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

import 'dashboard_quick_action.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({
    super.key,
    required this.onAgenda,
    required this.onRequests,
    required this.onEmployees,
    required this.onServices,
  });

  final VoidCallback onAgenda;
  final VoidCallback onRequests;
  final VoidCallback onEmployees;
  final VoidCallback onServices;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.15,
      children: [
        DashboardQuickAction(
          icon: Icons.calendar_month_rounded,
          title: 'Agenda',
          subtitle: 'Appuntamenti di oggi',
          onTap: onAgenda,
        ),
        DashboardQuickAction(
          icon: Icons.mark_email_unread_rounded,
          title: 'Richieste',
          subtitle: 'In attesa',
          onTap: onRequests,
        ),
        DashboardQuickAction(
          icon: Icons.badge_rounded,
          title: 'Dipendenti',
          subtitle: 'Turni e agenda',
          onTap: onEmployees,
        ),
        DashboardQuickAction(
          icon: Icons.content_cut_rounded,
          title: 'Servizi',
          subtitle: 'Listino prezzi',
          onTap: onServices,
        ),
      ],
    );
  }
}