import 'package:flutter/material.dart';

import '../widgets/admin_agenda_view.dart';

class AdminAgendaPage extends StatelessWidget {
  const AdminAgendaPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Agenda operativa',
        ),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Nuovo',
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: AdminAgendaView(),
      ),
    );
  }
}