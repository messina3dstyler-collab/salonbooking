import 'package:flutter/material.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({
    super.key,
    required this.salonId,
  });

  final String salonId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Impostazioni',
        ),
      ),
      body: Center(
        child: Text(
          'Impostazioni Admin\n'
              'Salone ID: $salonId',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}