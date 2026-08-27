import 'package:flutter/material.dart';

import '../models/appointment_request.dart';
import 'request_summary_card.dart';

class RequestDashboard extends StatelessWidget {
  const RequestDashboard({
    super.key,
    required this.requests,
  });

  final List<AppointmentRequest> requests;

  @override
  Widget build(BuildContext context) {
    final draft = requests.where((e) => e.isDraft).length;
    final pending = requests.where((e) => e.isPending).length;
    final accepted = requests.where((e) => e.isAccepted).length;
    final rejected = requests.where((e) => e.isRejected).length;
    final expired = requests.where((e) => e.isExpired).length;
    final closed = requests.where((e) => e.isClosed).length;
    final urgent = requests.where((e) => e.isUrgentPriority).length;

    final crossAxisCount =
    MediaQuery.of(context).size.width > 700 ? 3 : 2;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 2.2,
      children: [
        RequestSummaryCard(
          title: "Totali",
          value: requests.length.toString(),
          icon: Icons.list_alt,
        ),
        RequestSummaryCard(
          title: "Bozze",
          value: draft.toString(),
          icon: Icons.edit_document,
          color: Colors.blueGrey,
        ),
        RequestSummaryCard(
          title: "In attesa",
          value: pending.toString(),
          icon: Icons.schedule,
          color: Colors.orange,
        ),
        RequestSummaryCard(
          title: "Accettate",
          value: accepted.toString(),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        RequestSummaryCard(
          title: "Rifiutate",
          value: rejected.toString(),
          icon: Icons.cancel,
          color: Colors.red,
        ),
        RequestSummaryCard(
          title: "Scadute",
          value: expired.toString(),
          icon: Icons.timer_off,
          color: Colors.deepOrange,
        ),
        RequestSummaryCard(
          title: "Chiuse",
          value: closed.toString(),
          icon: Icons.inventory_2,
          color: Colors.indigo,
        ),
        RequestSummaryCard(
          title: "Urgenti",
          value: urgent.toString(),
          icon: Icons.priority_high,
          color: Colors.red,
        ),
      ],
    );
  }
}