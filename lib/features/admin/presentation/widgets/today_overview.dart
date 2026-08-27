import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

import '../../models/today_overview_model.dart';

import 'next_appointment_card.dart';
import 'team_status_card.dart';
import 'today_header.dart';
import 'today_revenue_card.dart';
import 'today_tasks_card.dart';

class TodayOverview extends StatelessWidget {
  const TodayOverview({
    super.key,
    required this.overview,
    this.onNextAppointment,
    this.onTasks,
    this.onTeam,
  });

  final TodayOverviewModel overview;

  final VoidCallback? onNextAppointment;
  final VoidCallback? onTasks;
  final VoidCallback? onTeam;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        TodayHeader(
          date: overview.date,
          appointments:
          overview.todayAppointments,
          pendingRequests:
          overview.pendingRequests,
          expectedRevenue:
          overview.revenue.expectedRevenue,
        ),

        const SizedBox(
          height: AppSpacing.xl,
        ),

        NextAppointmentCard(
          model: overview.nextAppointment,
          onTap: onNextAppointment,
        ),

        const SizedBox(
          height: AppSpacing.xl,
        ),

        TodayTasksCard(
          model: overview.tasks,
          onTap: onTasks,
        ),

        const SizedBox(
          height: AppSpacing.xl,
        ),

        TeamStatusCard(
          members: overview.team,
          onTap: onTeam,
        ),

        const SizedBox(
          height: AppSpacing.xl,
        ),

        TodayRevenueCard(
          model: overview.revenue,
        ),
      ],
    );
  }
}