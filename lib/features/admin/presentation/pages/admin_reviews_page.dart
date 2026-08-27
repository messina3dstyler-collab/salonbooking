import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../admin_providers.dart';
import '../../../review/pages/review_page.dart';

class AdminReviewsPage extends ConsumerWidget {
  const AdminReviewsPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final salonId =
    ref.watch(adminCurrentSalonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recensioni clienti',
        ),
      ),
      body: salonId.isEmpty
          ? const Center(
        child: Text(
          'Nessun salone selezionato',
        ),
      )
          : ReviewPage(
        salonId: salonId,
      ),
    );
  }
}