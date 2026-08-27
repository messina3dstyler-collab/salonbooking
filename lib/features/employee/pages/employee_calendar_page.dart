import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:salon_booking/features/employee/models/employee_model.dart';

import '../employee_calendar_providers.dart';
import '../models/employee_calendar_model.dart';
import '../widgets/employee_event_dialog.dart';
import '../widgets/employee_timeline.dart';

class EmployeeCalendarPage extends ConsumerStatefulWidget {
  const EmployeeCalendarPage({
    super.key,
    required this.employee,
  });

  final EmployeeModel employee;

  @override
  ConsumerState<EmployeeCalendarPage> createState() =>
      _EmployeeCalendarPageState();
}

class _EmployeeCalendarPageState
    extends ConsumerState<EmployeeCalendarPage> {
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadDay);
  }

  Future<void> _loadDay() async {
    await ref
        .read(employeeCalendarControllerProvider)
        .loadEvents(
          employeeId: widget.employee.id,
          date: _selectedDay,
        );
  }

  Future<void> _createEvent() async {
    final event =
        await showDialog<EmployeeCalendarModel>(
      context: context,
      builder: (_) => EmployeeEventDialog(
        employeeId: widget.employee.id,
      ),
    );

    if (event == null) {
      return;
    }

    try{
      await ref
          .read(employeeCalendarControllerProvider)
          .createEvent(event:event);

      await _loadDay();

      debugPrint('EVENTO SALVATO');
    }catch(e,st){
      debugPrint(e.toString());
      debugPrint(st.toString());

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:Text(e.toString())),
        );
      }
    }
  }
  Future<void> _onEventTap(
    EmployeeCalendarModel event,
  ) async {
    final action =
        await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Modifica'),
              onTap: () {
                Navigator.pop(
                  context,
                  'edit',
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Elimina'),
              onTap: () {
                Navigator.pop(
                  context,
                  'delete',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Annulla'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );

    if (!mounted || action == null) {
      return;
    }

    if (action == 'edit') {
      final updated =
          await showDialog<EmployeeCalendarModel>(
        context: context,
        builder: (_) => EmployeeEventDialog(
          employeeId: widget.employee.id,
          event: event,
        ),
      );

      if (updated == null) {
        return;
      }

      await ref
          .read(employeeCalendarControllerProvider)
          .updateEvent(
            event: updated,
          );

      await _loadDay();

      return;
    }

    if (action == 'delete') {
      final confirm =
          await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            'Eliminare evento?',
          ),
          content: const Text(
            'Questa operazione non può essere annullata.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Annulla',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Elimina',
              ),
            ),
          ],
        ),
      );

      if (confirm != true) {
        return;
      }

      await ref
          .read(employeeCalendarControllerProvider)
          .deleteEvent(
            eventId: event.id,
          );

      await _loadDay();
    }
  }
  bool _isEventValid(
      EmployeeCalendarModel event,
      ){
    final controller=
    ref.read(employeeCalendarControllerProvider);

    if(controller.hasConflict(
      start:event.startDate,
      end:event.endDate,
      ignoreEventId:event.id,
    )){
      return false;
    }

    if(!widget.employee.workingDays
        .contains(event.startDate.weekday)){
      return false;
    }

    final start=
        event.startDate.hour*60+
            event.startDate.minute;

    final end=
        event.endDate.hour*60+
            event.endDate.minute;

    if(start<widget.employee.startHour*60){
      return false;
    }

    if(end>widget.employee.endHour*60){
      return false;
    }

    if(widget.employee.hasBreak){
      if(start<widget.employee.breakEnd &&
          end>widget.employee.breakStart){
        return false;
      }
    }

    return true;
  }
  Future<void> _onEventMoved(
      EmployeeCalendarModel event,
      ) async {

    final controller=
    ref.read(employeeCalendarControllerProvider);

    if(controller.hasConflict(
      start:event.startDate,
      end:event.endDate,
      ignoreEventId:event.id,
    )){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Conflitto con un altro evento.',
            ),
          ),
        );
      }
      await _loadDay();
      return;
    }

    if(!widget.employee.workingDays
        .contains(event.startDate.weekday)){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Giorno non lavorativo.',
            ),
          ),
        );
      }
      await _loadDay();
      return;
    }

    final startMinutes=
        event.startDate.hour*60+
            event.startDate.minute;

    final endMinutes=
        event.endDate.hour*60+
            event.endDate.minute;

    final workStart=
        widget.employee.startHour*60;

    final workEnd=
        widget.employee.endHour*60;

    if(startMinutes<workStart||
        endMinutes>workEnd){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fuori orario di lavoro.',
            ),
          ),
        );
      }
      await _loadDay();
      return;
    }

    if(widget.employee.hasBreak){

      final breakStart=
          widget.employee.breakStart;

      final breakEnd=
          widget.employee.breakEnd;

      final overlap=
          startMinutes<breakEnd &&
              endMinutes>breakStart;

      if(overlap){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'L\'evento cade nella pausa pranzo.',
              ),
            ),
          );
        }
        await _loadDay();
        return;
      }
    }

    await controller.updateEvent(
      event:event,
    );

    await _loadDay();
  }
  @override
  Widget build(BuildContext context) {
    final controller =
        ref.watch(employeeCalendarControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agenda ${widget.employee.name}',
        ),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nuovo evento'),
        onPressed: _createEvent,
      ),
      body: Column(
        children: [

          TableCalendar(
            firstDay: DateTime.utc(2024),
            lastDay: DateTime.utc(2035),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) =>
                isSameDay(day, _selectedDay),
            eventLoader: controller.eventsForDay,
            onDaySelected: (
              selected,
              focused,
            ) async {
              setState(() {
                _selectedDay = selected;
              });

              await _loadDay();
            },
            calendarStyle: const CalendarStyle(
              markersMaxCount: 3,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (
                context,
                day,
                events,
              ) {
                if (events.isEmpty) {
                  return const SizedBox();
                }

                final calendarEvents =
                    events.cast<EmployeeCalendarModel>();

                return Positioned(
                  bottom: 3,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      calendarEvents.length > 3
                          ? 3
                          : calendarEvents.length,
                      (index) {
                        final event =
                            calendarEvents[index];

                        Color color;

                        switch (event.type) {
                          case CalendarEventType.vacation:
                            color = Colors.orange;
                            break;
                          case CalendarEventType.sick:
                            color = Colors.red;
                            break;
                          case CalendarEventType.breakTime:
                            color = Colors.brown;
                            break;
                          case CalendarEventType.meeting:
                            color = Colors.blue;
                            break;
                          case CalendarEventType.blocked:
                            color = Colors.black87;
                            break;
                        }

                        return Container(
                          width: 6,
                          height: 6,
                          margin:
                              const EdgeInsets.symmetric(
                            horizontal: 1,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _LegendItem(
                  color: Colors.orange,
                  label: 'Ferie',
                ),
                _LegendItem(
                  color: Colors.red,
                  label: 'Malattia',
                ),
                _LegendItem(
                  color: Colors.brown,
                  label: 'Pausa',
                ),
                _LegendItem(
                  color: Colors.blue,
                  label: 'Riunione',
                ),
                _LegendItem(
                  color: Colors.black87,
                  label: 'Bloccato',
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: controller.loading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : EmployeeTimeline(
              employee: widget.employee,
              events: controller.events,
              onEventTap: _onEventTap,
              onEventMoved: _onEventMoved,
              isEventValid: _isEventValid,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}