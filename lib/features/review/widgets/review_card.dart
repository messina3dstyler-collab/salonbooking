import 'package:flutter/material.dart';

import '../models/review_model.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
  });

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: review.userPhoto.isNotEmpty
                      ? NetworkImage(review.userPhoto)
                      : null,
                  child: review.userPhoto.isEmpty
                      ? Text(
                    review.userName.isEmpty
                        ? '?'
                        : review.userName[0].toUpperCase(),
                  )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName.isEmpty
                            ? 'Cliente'
                            : review.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: List.generate(
                          5,
                              (i) => Icon(
                            i < review.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  review.displayRating,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            if (review.comment.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                review.comment,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],

            if (review.serviceName.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Servizio: ${review.serviceName}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],

            if (review.employeeName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                ),
                child: Text(
                  'Operatore: ${review.employeeName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),

            const SizedBox(height: 6),

            Text(
              '${review.reviewDate.day.toString().padLeft(2, '0')}/'
                  '${review.reviewDate.month.toString().padLeft(2, '0')}/'
                  '${review.reviewDate.year}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}