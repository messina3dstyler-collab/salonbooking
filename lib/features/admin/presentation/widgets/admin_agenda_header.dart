import 'package:flutter/material.dart';

import '../../../employee/models/employee_model.dart';
import '../../models/admin_agenda_item.dart';

class AdminAgendaHeader extends StatelessWidget {
  const AdminAgendaHeader({
    super.key,
    required this.employees,
    required this.activeEmployees,
    required this.items,
    this.horizontalController,
  });

  final List<EmployeeModel> employees;
  final Map<String, bool> activeEmployees;
  final List<AdminAgendaItem> items;
  final ScrollController? horizontalController;

  static const double timeColumnWidth = 52;
  static const Color _gold = Color(0xFFD4AF37);

  Map<String, dynamic> _employeeStats(
    EmployeeModel employee,
  ) {
    final employeeItems = items
        .where(
          (e) => e.employeeName == employee.name,
        )
        .toList();

    final bookedMinutes =
        employeeItems.fold<int>(
      0,
      (sum, item) =>
          sum + item.duration.inMinutes,
    );

    const workMinutes = 12 * 60;

    final occupancy =
        (bookedMinutes / workMinutes)
            .clamp(0.0, 1.0);

    Color color;

    if (occupancy < .35) {
      color = Colors.green;
    } else if (occupancy < .70) {
      color = _gold;
    } else {
      color = Colors.red;
    }

    return {
      "appointments": employeeItems.length,
      "minutes": bookedMinutes,
      "occupancy": occupancy,
      "color": color,
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        double employeeColumnWidth;

        if (width < 430) {
          employeeColumnWidth = 165;
        } else if (width < 900) {
          employeeColumnWidth = 190;
        } else {
          employeeColumnWidth = 220;
        }

        return Container(
          height: 84,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCF8),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: .04,
                ),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [

              //------------------------------------------------
              // COLONNA ORARI
              //------------------------------------------------

              Container(
                width: timeColumnWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    right: BorderSide(
                      color: _gold.withValues(
                        alpha: .20,
                      ),
                    ),
                  ),
                ),
                child: const RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "ORA",
                    style: TextStyle(
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),

              //------------------------------------------------
              // OPERATORI
              //------------------------------------------------

              Expanded(
                child: ListView.separated(
                  controller:
                      horizontalController,
                  scrollDirection:
                      Axis.horizontal,
                  physics:
                      const ClampingScrollPhysics(),
                  itemCount: employees.length,
                  separatorBuilder:
                      (context, index) =>
                          Container(
                    width: 1,
                    color: _gold.withValues(
                      alpha: .10,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final employee =
                        employees[index];

                    final isActive =
                        activeEmployees[
                                employee.id] ??
                            false;

                    final stats =
                        _employeeStats(
                      employee,
                    );

                    final occupancy =
                        stats["occupancy"]
                            as double;

                    final appointments =
                        stats["appointments"]
                            as int;

                    final statColor =
                        stats["color"] as Color;

                    final initial =
                        employee.name.isEmpty
                            ? "?"
                            : employee.name
                                .characters
                                .first
                                .toUpperCase();
                    return AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                      curve: Curves.easeOut,
                      width: employeeColumnWidth,
                      decoration: BoxDecoration(
                        color: isActive
                            ? _gold.withValues(
                                alpha: .05,
                              )
                            : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: isActive
                                ? _gold
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [

                            //--------------------------------
                            // AVATAR
                            //--------------------------------

                            Stack(
                              clipBehavior: Clip.none,
                              children: [

                                AnimatedContainer(
                                  duration:
                                      const Duration(
                                    milliseconds: 220,
                                  ),
                                  width:
                                      isActive ? 38 : 34,
                                  height:
                                      isActive ? 38 : 34,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        _gold,
                                    child: Text(
                                      initial,
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.black,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: -4,
                                  left: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          statColor,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        30,
                                      ),
                                    ),
                                    child: Text(
                                      "${(occupancy * 100).round()}%",
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white,
                                        fontSize: 9,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),
                                ),

                                if (isActive)
                                  Positioned(
                                    right: -1,
                                    bottom: -1,
                                    child: Container(
                                      width: 11,
                                      height: 11,
                                      decoration:
                                          BoxDecoration(
                                        color:
                                            Colors.green,
                                        shape:
                                            BoxShape
                                                .circle,
                                        border:
                                            Border.all(
                                          color: Colors
                                              .white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(width: 12),

                            //--------------------------------
                            // TESTI
                            //--------------------------------

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [

                                  Text(
                                    employee
                                            .name
                                            .isEmpty
                                        ? "Operatore"
                                        : employee.name,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight
                                              .w800,
                                      color: isActive
                                          ? const Color(
                                              0xFF8A6A00,
                                            )
                                          : Colors
                                              .black87,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 2,
                                  ),

                                  Text(
                                    employee
                                            .specialization
                                            .isEmpty
                                        ? "Operatore"
                                        : employee
                                            .specialization,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        TextStyle(
                                      fontSize: 11,
                                      color: Colors
                                          .grey
                                          .shade600,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 7,
                                  ),
                                  LinearProgressIndicator(
                                    value: occupancy,
                                    minHeight: 5,
                                    backgroundColor:
                                        Colors.grey.shade200,
                                    valueColor:
                                        AlwaysStoppedAnimation(
                                      statColor,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                      100,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 5,
                                  ),

                                  Row(
                                    children: [

                                      Icon(
                                        Icons.event_available,
                                        size: 12,
                                        color: Colors.grey.shade600,
                                      ),

                                      const SizedBox(width: 4),

                                      Text(
                                        "$appointments appuntamenti",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight.w600,
                                          color: Colors
                                              .grey
                                              .shade600,
                                        ),
                                      ),

                                      const Spacer(),

                                      _EmployeeStatusBadge(
                                        active: isActive,
                                      ),

                                      const SizedBox(width: 5),

                                      Text(
                                        isActive
                                            ? "Occupato"
                                            : "Libero",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: isActive
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmployeeStatusBadge
    extends StatelessWidget {
  const _EmployeeStatusBadge({
    required this.active,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: active
            ? Colors.green
            : Colors.grey.shade400,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (active
                    ? Colors.green
                    : Colors.grey)
                .withValues(alpha: .22),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}