import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';

import '../../home_providers.dart';
import '../../../salon/salon_providers.dart';

import '../widgets/home_header.dart';
import '../widgets/next_booking_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/statistics_section.dart';

import '../../../salon/presentation/widgets/salon_card.dart';
import '../../../salon/presentation/pages/salon_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(homeControllerProvider).loadUser();
      ref.read(salonControllerProvider).loadSalons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(homeControllerProvider);
    final salonController = ref.watch(salonControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(userName: controller.user?.name ?? 'Cliente'),

              const SizedBox(height: AppSpacing.xl),

              const NextBookingCard(),

              const SizedBox(height: AppSpacing.xxl),

              const QuickActions(),

              const SizedBox(height: AppSpacing.xxl),

              const StatisticsSection(),
              const SizedBox(height: AppSpacing.xxl),

              Text('Saloni disponibili', style: AppTextStyles.titleLarge),

              const SizedBox(height: AppSpacing.lg),

              if (salonController.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (salonController.salons.isEmpty)
                const Center(child: Text('Nessun salone disponibile'))
              else
                ...salonController.salons.map(
                  (salon) => SalonCard(
                    salon: salon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SalonDetailPage(salon: salon),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
