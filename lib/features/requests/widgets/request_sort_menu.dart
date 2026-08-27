import 'package:flutter/material.dart';

enum RequestSort {
  newest,
  oldest,
  priority,
  status,
  customer,
}

class RequestSortMenu extends StatelessWidget {
  const RequestSortMenu({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final RequestSort value;
  final ValueChanged<RequestSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<RequestSort>(
      tooltip: "Ordina",
      icon: const Icon(Icons.sort),
      onSelected: onChanged,
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: RequestSort.newest,
          child: Text("Più recenti"),
        ),
        PopupMenuItem(
          value: RequestSort.oldest,
          child: Text("Meno recenti"),
        ),
        PopupMenuItem(
          value: RequestSort.priority,
          child: Text("Priorità"),
        ),
        PopupMenuItem(
          value: RequestSort.status,
          child: Text("Stato"),
        ),
        PopupMenuItem(
          value: RequestSort.customer,
          child: Text("Cliente"),
        ),
      ],
    );
  }
}