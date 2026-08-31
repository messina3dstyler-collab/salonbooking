enum AppointmentFilter {
  all(
    'Tutti',
  ),

  pending(
    'Prenotati',
  ),

  confirmed(
    'Confermati',
  ),

  completed(
    'Completati',
  ),

  cancelled(
    'Annullati',
  );

  const AppointmentFilter(
      this.label,
      );

  final String label;

  bool matches(String status) {
    final normalized = status.trim().toLowerCase();

    switch (this) {
      case AppointmentFilter.all:
        return true;

      case AppointmentFilter.pending:
        return normalized == 'prenotata';

      case AppointmentFilter.confirmed:
        return normalized == 'confermata';

      case AppointmentFilter.completed:
        return normalized == 'completata';

      case AppointmentFilter.cancelled:
        return normalized == 'annullata';
    }
  }
}