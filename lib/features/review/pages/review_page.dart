import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../review_providers.dart';
import '../widgets/review_card.dart';

class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({
    super.key,
    required this.salonId,
  });

  final String salonId;

  @override
  ConsumerState<ReviewPage> createState() =>
      _ReviewPageState();
}

class _ReviewPageState
    extends ConsumerState<ReviewPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(_load);
  }

  void _load() {
    ref
        .read(reviewControllerProvider)
        .loadReviews(
      salonId: widget.salonId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller =
    ref.watch(reviewControllerProvider);

    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            controller.error!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (controller.reviews.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          children: const [
            SizedBox(
              height: 350,
              child: Center(
                child: Text(
                  'Nessuna recensione disponibile',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            elevation: 1,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              child: Column(
                children: [
                  const Text(
                    'Valutazione media',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${controller.averageRating.toStringAsFixed(1)} ⭐',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${controller.reviewCount} recensioni',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          ...controller.reviews.map(
                (review) => ReviewCard(
              review: review,
            ),
          ),
        ],
      ),
    );
  }
}