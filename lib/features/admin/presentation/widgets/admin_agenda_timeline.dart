import 'package:flutter/material.dart';

import '../../../employee/models/employee_model.dart';
import '../../models/admin_agenda_item.dart';
import 'admin_agenda_block.dart';
import 'package:intl/intl.dart';

class AdminAgendaTimeline extends StatelessWidget {
  const AdminAgendaTimeline({
    super.key,
    required this.employees,
    required this.items,
    required this.activeEmployees,
    required this.pulseAnimation,
    required this.onAppointmentTap,
    this.verticalController,
    this.horizontalController,
  });

  final List<EmployeeModel> employees;
  final List<AdminAgendaItem> items;
  final Map<String, bool> activeEmployees;
  final Animation<double> pulseAnimation;
  final ValueChanged<AdminAgendaItem> onAppointmentTap;

  final ScrollController? verticalController;
  final ScrollController? horizontalController;

  static const double hourHeight = 60;
  static const double timeColumnWidth = 52;

  static const Color _gold = Color(0xFFD4AF37);

  static const int workStartHour = 8;
  static const int workEndHour = 20;

  static const Color _workColor = Colors.white;
  static const Color _offWorkColor = Color(0xFFF6F3ED);
  double _hourOccupancy(int hour) {
    int occupiedMinutes = 0;

    for (final item in items) {
      final hourStart = DateTime(
        item.start.year,
        item.start.month,
        item.start.day,
        hour,
      );

      final hourEnd = hourStart.add(
        const Duration(hours: 1),
      );

      final overlapStart =
      item.start.isAfter(hourStart)
          ? item.start
          : hourStart;

      final overlapEnd =
      item.end.isBefore(hourEnd)
          ? item.end
          : hourEnd;

      if (overlapEnd.isAfter(overlapStart)) {
        occupiedMinutes = (occupiedMinutes +
            overlapEnd
                .difference(overlapStart)
                .inMinutes)
            .clamp(0, 60);
      }
    }

    return occupiedMinutes / 60;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nowLabel = DateFormat(
      'HH:mm',
      'it_IT',
    ).format(now);

    final currentTop =
        ((now.hour * 60) + now.minute) * hourHeight / 60;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        double employeeColumnWidth;

        if (width < 430) {
          employeeColumnWidth = 140;
        } else if (width < 900) {
          employeeColumnWidth = 170;
        } else {
          employeeColumnWidth = 200;
        }

        return Container(
          color: const Color(0xFFFFFCF8),
          child: Scrollbar(
            controller: verticalController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: verticalController,
              child: SizedBox(
                height: hourHeight * 24,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// COLONNA ORARI

                    Container(
                      width: timeColumnWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: _gold.withValues(alpha: .25),
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .04),
                            blurRadius: 10,
                            offset: const Offset(2, 0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [

                          Column(
                            children: List.generate(
                              24,
                                  (hour) {
                                final isWorkingHour =
                                    hour >= workStartHour &&
                                        hour < workEndHour;
                                final occupancy = _hourOccupancy(hour);
                                final occupancyPercent =
                                (occupancy * 100).round();

                                return Container(
                                  height: hourHeight,
                                  decoration: BoxDecoration(
                                    color: isWorkingHour
                                        ? _workColor
                                        : _offWorkColor,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [

                                        Tooltip(
                                          message:
                                          occupancy == 0
                                              ? 'Ora libera'
                                              : occupancy < .35
                                              ? 'Occupazione bassa ($occupancyPercent%)'
                                              : occupancy < .70
                                              ? 'Occupazione media ($occupancyPercent%)'
                                              : 'Fascia molto richiesta ($occupancyPercent%)',
                                          waitDuration: const Duration(milliseconds: 250),
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 280),
                                            curve: Curves.easeOutCubic,
                                            width: 5,
                                            height: occupancy == 0
                                                ? 4
                                                : 10 + (40 * occupancy),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(99),
                                              gradient: occupancy == 0
                                                  ? null
                                                  : LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: occupancy < .35
                                                    ? const [
                                                  Color(0xFF7DDC7A),
                                                  Color(0xFF2EAF4A),
                                                ]
                                                    : occupancy < .70
                                                    ? const [
                                                  Color(0xFFFFE8A3),
                                                  Color(0xFFD4AF37),
                                                ]
                                                    : const [
                                                  Color(0xFFFF8A80),
                                                  Color(0xFFE53935),
                                                ],
                                              ),
                                              boxShadow: occupancy == 0
                                                  ? null
                                                  : [
                                                BoxShadow(
                                                  color: occupancy < .35
                                                      ? Colors.green.withValues(
                                                    alpha: .18,
                                                  )
                                                      : occupancy < .70
                                                      ? _gold.withValues(
                                                    alpha: .22,
                                                  )
                                                      : Colors.red.withValues(
                                                    alpha: .22,
                                                  ),
                                                  blurRadius: 7,
                                                  spreadRadius: .4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 6),

                                        Expanded(
                                          child: Text(
                                            '${hour.toString().padLeft(2, '0')}:00',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: now.hour == hour
                                                  ? Colors.red
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          Positioned(
                            top: currentTop - 4,
                            right: 0,
                            child: AnimatedBuilder(
                              animation: pulseAnimation,
                              builder: (_, child) {
                                return Transform.scale(
                                  scale: pulseAnimation.value,
                                  child: child,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withValues(alpha: .30),
                                      blurRadius: 12,
                                      spreadRadius: (pulseAnimation.value - 1) * 3,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Adesso  $nowLabel',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: .2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// COLONNE OPERATORI

                    Expanded(
                      child: Scrollbar(
                        controller: horizontalController,
                        thumbVisibility: true,
                        notificationPredicate: (_) => true,
                        child: ListView.builder(
                          controller: horizontalController,
                          scrollDirection: Axis.horizontal,
                          itemCount: employees.length,
                          itemBuilder: (_, index) {
                            final employee = employees[index];
                            final isActive =
                                activeEmployees[employee.id] ?? false;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              width: employeeColumnWidth,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? _gold.withValues(alpha: .045)
                                    : Colors.transparent,
                                border: Border(
                                  left: BorderSide(
                                    color: isActive
                                        ? _gold.withValues(alpha: .18)
                                        : Colors.transparent,
                                  ),
                                  right: BorderSide(
                                    color: isActive
                                        ? _gold.withValues(alpha: .18)
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [

                                  /// SFONDO ORA CORRENTE

                                  Positioned(
                                    top: currentTop - 18,
                                    left: 0,
                                    right: 0,
                                    child: IgnorePointer(
                                      child: Container(
                                        height: 36,
                                        color: isActive
                                            ? _gold.withValues(alpha: .08)
                                            : Colors.red.withValues(alpha: .035),
                                      ),
                                    ),
                                  ),

                                  /// GRIGLIA

                                  Column(
                                    children: List.generate(
                                      24,
                                          (hour) {
                                        final isWorkingHour =
                                            hour >= workStartHour &&
                                                hour < workEndHour;

                                        return Container(
                                          height: hourHeight,
                                          color: isWorkingHour
                                              ? _workColor
                                              : _offWorkColor,
                                          child: Stack(
                                            children: [

                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 1,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),

                                              Positioned(
                                                top: hourHeight / 2,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  height: .8,
                                                  color: Colors.grey.shade100,
                                                ),
                                              ),

                                              Positioned(
                                                top: 0,
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  width: 1,
                                                  color: _gold.withValues(alpha: .12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  /// LINEA ORA CORRENTE

                                  Positioned(
                                    top: currentTop,
                                    left: 0,
                                    right: 0,
                                    child: IgnorePointer(
                                      child: Row(
                                        children: [
                                          AnimatedBuilder(
                                            animation: pulseAnimation,
                                            builder: (_, child) {
                                              return Transform.scale(
                                                scale: pulseAnimation.value,
                                                child: child,
                                              );
                                            },
                                            child: Container(
                                              width: 9,
                                              height: 9,
                                              decoration: BoxDecoration(
                                                color: isActive
                                                    ? _gold
                                                    : Colors.red,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: (isActive ? _gold : Colors.red)
                                                        .withValues(alpha: .45),
                                                    blurRadius: 10,
                                                    spreadRadius: (pulseAnimation.value - 1) * 3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 250),
                                              height: isActive ? 3 : 2,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: isActive
                                                      ? [
                                                    const Color(0xFFE0BC47),
                                                    _gold,
                                                  ]
                                                      : [
                                                    Colors.red,
                                                    Colors.red.withValues(alpha: .45),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  /// APPUNTAMENTI

                                  ...items
                                      .where((e) =>
                                  e.employeeName == employee.name)
                                      .map((item) {
                                    final top =
                                        ((item.start.hour * 60) +
                                            item.start.minute) *
                                            hourHeight /
                                            60;

                                    final height =
                                        item.duration.inMinutes *
                                            hourHeight /
                                            60;

                                    return Positioned(
                                      left: 8,
                                      right: 8,
                                      top: top,
                                      height: height < 34 ? 34 : height,
                                      child: AdminAgendaBlock(
                                      item: item,
                                      pulseAnimation: pulseAnimation,
                                      onTap: () => onAppointmentTap(item),
                                    ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}