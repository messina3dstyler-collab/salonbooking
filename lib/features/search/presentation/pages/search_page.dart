import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';

import '../../../salon/salon_providers.dart';
import '../../../salon/models/salon_model.dart';
import '../../../salon/presentation/pages/salon_detail_page.dart';
import '../../../salon/presentation/widgets/salon_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  String query = '';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(salonControllerProvider).loadSalons();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salonController = ref.watch(salonControllerProvider);

    List<SalonModel> salons =
        salonController.salons.where((salon) {
          final text = query.toLowerCase();

          return salon.name.toLowerCase().contains(text) ||
              salon.city.toLowerCase().contains(text);
        }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(title: const Text("Cerca saloni")),

      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Nome o città",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            if (salonController.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (salons.isEmpty)
              const Expanded(
                child: Center(child: Text("Nessun salone trovato")),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: salons.length,
                  itemBuilder: (context, index) {
                    final salon = salons[index];

                    return SalonCard(
                      salon: salon,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalonDetailPage(salon: salon),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
