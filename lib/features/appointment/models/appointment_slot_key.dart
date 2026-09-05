class AppointmentSlotKey {
  AppointmentSlotKey._();

  /// Intervallo minimo utilizzato dal sistema di prenotazione.
  static const int slotMinutes = 30;

  /// Restituisce l'identificativo deterministico di uno slot.
  ///
  /// Esempio:
  /// salon_1 + employee_2 + 2026-09-05 + 10:30
  ///
  /// diventa:
  /// salon_1_employee_2_20260905_1030
  static String build({
    required String salonId,
    required String employeeId,
    required DateTime start,
  }) {
    final normalizedSalonId = salonId.trim();
    final normalizedEmployeeId = employeeId.trim();

    if (normalizedSalonId.isEmpty) {
      throw ArgumentError(
        'salonId non può essere vuoto.',
      );
    }

    if (normalizedEmployeeId.isEmpty) {
      throw ArgumentError(
        'employeeId non può essere vuoto.',
      );
    }

    final date = _formatDate(start);
    final time = _formatTime(start);

    return '${_sanitize(normalizedSalonId)}'
        '_${_sanitize(normalizedEmployeeId)}'
        '_${date}_$time';
  }

  /// Genera tutti gli slot da riservare per un servizio.
  ///
  /// Esempio:
  /// inizio 10:00, durata 60 minuti
  ///
  /// restituisce:
  /// 10:00
  /// 10:30
  ///
  /// Per una durata di 45 minuti:
  /// 10:00
  /// 10:30
  ///
  /// In questo modo anche una prenotazione più lunga
  /// occupa tutti i blocchi temporali interessati.
  static List<DateTime> buildSlots({
    required DateTime start,
    required int durationMinutes,
  }) {
    if (durationMinutes <= 0) {
      throw ArgumentError(
        'La durata deve essere maggiore di zero.',
      );
    }

    final normalizedStart = DateTime(
      start.year,
      start.month,
      start.day,
      start.hour,
      start.minute,
    );

    final slotCount =
        (durationMinutes + slotMinutes - 1) ~/ slotMinutes;

    return List<DateTime>.generate(
      slotCount,
          (index) => normalizedStart.add(
        Duration(
          minutes: index * slotMinutes,
        ),
      ),
    );
  }

  static String _formatDate(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}'
        '${value.month.toString().padLeft(2, '0')}'
        '${value.day.toString().padLeft(2, '0')}';
  }

  static String _formatTime(DateTime value) {
    return '${value.hour.toString().padLeft(2, '0')}'
        '${value.minute.toString().padLeft(2, '0')}';
  }

  static String _sanitize(String value) {
    return value
        .replaceAll('/', '_')
        .replaceAll(' ', '_');
  }
}