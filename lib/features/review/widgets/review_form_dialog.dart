import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointment/models/appointment_model.dart';
import '../models/review_model.dart';
import '../review_providers.dart';

class ReviewFormDialog extends ConsumerStatefulWidget {
  const ReviewFormDialog({
    super.key,
    required this.appointment,
  });

  final AppointmentModel appointment;

  @override
  ConsumerState<ReviewFormDialog> createState() =>
      _ReviewFormDialogState();
}

class _ReviewFormDialogState
    extends ConsumerState<ReviewFormDialog> {
  double _rating = 0;

  final _comment = TextEditingController();

  bool _saving = false;

  Future<void> _save() async {
    if (_rating <= 0) return;

    final appointment = widget.appointment;

    if (appointment.hasReview) {
      Navigator.pop(context, false);
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      //----------------------------------------------------------
      // Recupero dati utente
      //----------------------------------------------------------

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(appointment.userId)
          .get();

      final userData = userDoc.data();

      final userName =
      (userData?['name'] ?? '').toString();

      final userPhoto =
      (userData?['photoUrl'] ??
          userData?['photo'] ??
          '')
          .toString();

      //----------------------------------------------------------
      // Id recensione
      //----------------------------------------------------------

      final reviewId = FirebaseFirestore.instance
          .collection('salons')
          .doc(appointment.salonId)
          .collection('reviews')
          .doc()
          .id;

      final review = ReviewModel(
        id: reviewId,

        salonId: appointment.salonId,
        userId: appointment.userId,
        appointmentId: appointment.id,

        userName: userName,
        userPhoto: userPhoto,

        employeeId: appointment.employeeId,
        employeeName: appointment.employeeName,
        employeePhone: appointment.employeePhone,
        employeeSpecialization:
        appointment.employeeSpecialization,
        employeeRating:
        appointment.employeeRating,

        serviceId: appointment.serviceId,
        serviceName: appointment.serviceName,

        rating: _rating,
        comment: _comment.text.trim(),

        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await ref
          .read(reviewControllerProvider)
          .createReview(
        review: review,
      );

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Errore salvataggio recensione:\n$e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;

    return AlertDialog(
      title: const Text(
        'Lascia una recensione',
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appointment.employeeName.isEmpty
                  ? 'Operatore'
                  : appointment.employeeName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),

            if (appointment.employeeSpecialization
                .isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                appointment.employeeSpecialization,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) => IconButton(
                  onPressed: _saving
                      ? null
                      : () {
                    setState(() {
                      _rating =
                          index + 1.0;
                    });
                  },
                  icon: Icon(
                    index < _rating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 34,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _comment,
              maxLines: 4,
              textCapitalization:
              TextCapitalization.sentences,
              decoration:
              const InputDecoration(
                labelText: 'Commento',
                hintText:
                'Racconta la tua esperienza...',
                border:
                OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving
              ? null
              : () => Navigator.pop(
            context,
            false,
          ),
          child: const Text(
            'Annulla',
          ),
        ),
        ElevatedButton(
          onPressed: _saving || _rating == 0
              ? null
              : _save,
          child: _saving
              ? const SizedBox(
            width: 18,
            height: 18,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
              : const Text(
            'Pubblica',
          ),
        ),
      ],
    );
  }
}