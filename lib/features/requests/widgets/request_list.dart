import 'package:flutter/material.dart';

import '../models/appointment_request.dart';
import 'request_card.dart';
import 'request_empty_state.dart';

class RequestList extends StatelessWidget {
  const RequestList({
    super.key,
    required this.requests,
    this.loading = false,
    this.error,
    this.onTap,
  });

  final List<AppointmentRequest> requests;
  final bool loading;
  final String? error;
  final ValueChanged<AppointmentRequest>? onTap;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error?.isNotEmpty == true) {
      return Center(
        child: Text(error!),
      );
    }

    if (requests.isEmpty) {
      return const RequestEmptyState();
    }

    return ListView.separated(
      itemCount: requests.length,
      separatorBuilder: (_, _) =>
      const SizedBox(height: 12),
      itemBuilder: (_, index) => RequestCard(
        request: requests[index],
        onTap: onTap == null
            ? null
            : () => onTap!(requests[index]),
      ),
    );
  }
}