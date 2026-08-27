import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

import '../../models/employee_status.dart';
import '../../models/team_member_model.dart';

class TeamStatusCard extends StatelessWidget {
  const TeamStatusCard({
    super.key,
    required this.members,
    this.onTap,
  });

  final List<TeamMemberModel> members;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        onTap: members.isEmpty ? null : onTap,
        child: Ink(
          padding: const EdgeInsets.all(
            AppSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(
              AppRadius.lg,
            ),
            border: Border.all(
              color: AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: .04,
                ),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TEAM DI OGGI',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (members.isEmpty)
                const _EmptyTeam()
              else
                ...members.map(
                      (member) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.lg,
                    ),
                    child: _EmployeeTile(
                      member: member,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.member,
  });

  final TeamMemberModel member;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final String statusLabel;

    switch (member.status) {
      case EmployeeStatus.available:
        color = AppColors.success;
        statusLabel = 'Disponibile';

      case EmployeeStatus.busy:
        color = AppColors.primary;
        statusLabel = 'Occupato';

      case EmployeeStatus.pause:
        color = Colors.orange;
        statusLabel = 'In pausa';

      case EmployeeStatus.offline:
        color = Colors.grey;
        statusLabel = 'Assente';
    }

    final subtitle = member.status == EmployeeStatus.offline
        ? 'Non in servizio'
        : member.hasCurrentCustomer
        ? 'Con ${member.currentCustomer}'
        : member.hasNextAppointment
        ? 'Prossimo ${member.nextAppointmentTime}'
        : 'Nessun appuntamento';

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color.withValues(alpha: .12),
          backgroundImage: member.hasAvatar
              ? NetworkImage(
            member.avatarUrl,
          )
              : null,
          child: member.hasAvatar
              ? null
              : Text(
            member.name.isEmpty
                ? '?'
                : member.name.characters.first.toUpperCase(),
            style: AppTextStyles.titleMedium.copyWith(
              color: color,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            statusLabel,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyTeam extends StatelessWidget {
  const _EmptyTeam();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
      ),
      child: Column(
        children: [
          Icon(
            Icons.groups_rounded,
            size: 42,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Nessun operatore presente',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Il team non è in servizio.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}