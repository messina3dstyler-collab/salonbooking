import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';

import '../../../requests/pages/requests_page.dart';
import '../../../requests/request_providers.dart';
import '../../admin_providers.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../../providers/current_salon_provider.dart';

import 'admin_agenda_page.dart';
import 'admin_employees_page.dart';
import 'admin_services_page.dart';
import 'admin_appointments_page.dart';

import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/dashboard_statistics_grid.dart';
import '../widgets/today_overview.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({
    super.key,
    required this.salonId,
  });

  final String salonId;

  @override
  ConsumerState<AdminDashboardPage> createState() =>
      _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();

    _syncSalonId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadDashboard();
    });
  }

  @override
  void didUpdateWidget(covariant AdminDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.salonId != widget.salonId) {
      _syncSalonId();
      _loadDashboard();
    }
  }

  void _syncSalonId() {
    ref.read(currentSalonIdProvider.notifier).state = widget.salonId;
  }

  void _loadDashboard() {
    ref.read(adminDashboardControllerProvider).loadDashboard(
      salonId: widget.salonId,
    );
  }

  void _openPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  void _openRequests() {
    ref.read(requestControllerProvider).bindPending(
      widget.salonId,
    );

    _openPage(
      const RequestsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AdminDashboardController controller = ref.watch(
      adminDashboardControllerProvider,
    );

    if (controller.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (controller.error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Impossibile caricare la dashboard',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Controlla la connessione e riprova.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: _loadDashboard,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Riprova'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final dashboard = controller.dashboard;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Panoramica del salone',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                TodayOverview(
                  overview: dashboard.todayOverview,
                  onNextAppointment: () {
                    _openPage(
                      const AdminAgendaPage(),
                    );
                  },
                  onTasks: () {
                    _openPage(
                      const AdminAppointmentsPage(),
                    );
                  },
                  onTeam: () {
                    _openPage(
                      const AdminEmployeesPage(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                const DashboardSectionTitle(
                  title: 'Statistiche',
                  subtitle: 'Andamento del salone',
                ),
                const SizedBox(height: AppSpacing.lg),
                DashboardStatisticsGrid(
                  dashboard: dashboard,
                  onAppointments: () {
                    _openPage(
                      const AdminAppointmentsPage(),
                    );
                  },
                  onEmployees: () {
                    _openPage(
                      const AdminEmployeesPage(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                const DashboardSectionTitle(
                  title: 'Azioni rapide',
                  subtitle: 'Le operazioni più utilizzate',
                ),
                const SizedBox(height: AppSpacing.lg),
                DashboardQuickActions(
                  onAgenda: () {
                    _openPage(
                      const AdminAgendaPage(),
                    );
                  },
                  onRequests: _openRequests,
                  onEmployees: () {
                    _openPage(
                      const AdminEmployeesPage(),
                    );
                  },
                  onServices: () {
                    _openPage(
                      const AdminServicesPage(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}