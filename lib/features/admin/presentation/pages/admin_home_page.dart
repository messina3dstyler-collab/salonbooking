import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/current_salon_provider.dart';

import '../widgets/admin_agenda_view.dart';
import '../widgets/admin_header.dart';
import '../widgets/admin_menu_card.dart';
import '../widgets/section_title.dart';

import 'admin_appointments_page.dart';
import 'admin_dashboard_page.dart';
import 'admin_employees_page.dart';
import 'admin_reviews_page.dart';
import 'admin_salon_page.dart';
import 'admin_services_page.dart';
import 'admin_settings_page.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({
    super.key,
    required this.salonId,
  });

  final String salonId;

  @override
  ConsumerState<AdminHomePage> createState() =>
      _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    _syncSalonId();
  }

  @override
  void didUpdateWidget(covariant AdminHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.salonId != widget.salonId) {
      _syncSalonId();
    }
  }

  void _syncSalonId() {
    ref.read(currentSalonIdProvider.notifier).state = widget.salonId;
  }

  void _openPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Pannello Amministratore',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminHeader(
              adminName: 'Federico',
              salonName: 'SalonBooking',
            ),
            const SizedBox(height: 24),
            const SectionTitle(
              title: 'Agenda operativa',
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 760,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: AdminAgendaView(),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const SectionTitle(
              title: 'Gestione',
            ),
            const SizedBox(height: 16),
            AdminMenuCard(
              icon: Icons.calendar_month,
              title: 'Appuntamenti',
              subtitle: 'Gestisci prenotazioni',
              onTap: () {
                _openPage(
                  const AdminAppointmentsPage(),
                );
              },
            ),
            AdminMenuCard(
              icon: Icons.people,
              title: 'Dipendenti',
              subtitle: 'Gestisci operatori',
              onTap: () {
                _openPage(
                  const AdminEmployeesPage(),
                );
              },
            ),
            AdminMenuCard(
              icon: Icons.content_cut,
              title: 'Servizi',
              subtitle: 'Prezzi e durata',
              onTap: () {
                _openPage(
                  const AdminServicesPage(),
                );
              },
            ),
            AdminMenuCard(
              icon: Icons.store,
              title: 'Salone',
              subtitle: 'Informazioni salone',
              onTap: () {
                _openPage(
                  AdminSalonPage(
                    salonId: widget.salonId,
                  ),
                );
              },
            ),
            AdminMenuCard(
              icon: Icons.star,
              title: 'Recensioni',
              subtitle: 'Gestisci recensioni',
              onTap: () {
                _openPage(
                  const AdminReviewsPage(),
                );
              },
            ),
            AdminMenuCard(
              icon: Icons.bar_chart,
              title: 'Dashboard',
              subtitle: 'Statistiche avanzate',
              onTap: () {
                _openPage(
                  AdminDashboardPage(
                    salonId: widget.salonId,
                  ),
                );
              },
            ),
            AdminMenuCard(
              icon: Icons.settings,
              title: 'Impostazioni',
              subtitle: 'Configura il salone',
              onTap: () {
                _openPage(
                  AdminSettingsPage(
                    salonId: widget.salonId,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}