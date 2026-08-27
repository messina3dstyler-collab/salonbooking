import 'package:flutter/material.dart';

import '../models/employee_calendar_model.dart';

class EmployeeEventBlock extends StatefulWidget {
  const EmployeeEventBlock({
    super.key,
    required this.event,
    required this.hourHeight,
    required this.isValid,
    required this.onTap,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onResizeStart,
    this.onResizeUpdate,
    this.onResizeEnd,
  });

  final EmployeeCalendarModel event;
  final double hourHeight;
  final bool isValid;

  final VoidCallback onTap;
  final VoidCallback? onDragStart;
  final ValueChanged<Offset>? onDragUpdate;
  final VoidCallback? onDragEnd;
  final VoidCallback? onResizeStart;
  final ValueChanged<Offset>? onResizeUpdate;
  final VoidCallback? onResizeEnd;

  @override
  State<EmployeeEventBlock> createState() =>
      _EmployeeEventBlockState();
}

class _EmployeeEventBlockState
    extends State<EmployeeEventBlock> {

  bool _hover = false;
  bool _pressed = false;
  bool _dragging = false;
  bool _resizing = false;

  double get top {
    final start = widget.event.startDate;

    return ((start.hour * 60) + start.minute) *
        widget.hourHeight /
        60;
  }

  double get height {
    final value = widget.event.endDate
            .difference(widget.event.startDate)
            .inMinutes *
        widget.hourHeight /
        60;

    return value < 40 ? 40 : value;
  }

  Color get color {
    if (!widget.isValid) {
      return Colors.red;
    }

    switch (widget.event.type) {
      case CalendarEventType.vacation:
        return Colors.orange;

      case CalendarEventType.sick:
        return Colors.red;

      case CalendarEventType.breakTime:
        return Colors.brown;

      case CalendarEventType.meeting:
        return Colors.blue;

      case CalendarEventType.blocked:
        return Colors.black87;
    }
  }

  IconData get icon {
    switch (widget.event.type) {
      case CalendarEventType.vacation:
        return Icons.beach_access;

      case CalendarEventType.sick:
        return Icons.sick;

      case CalendarEventType.breakTime:
        return Icons.coffee;

      case CalendarEventType.meeting:
        return Icons.groups;

      case CalendarEventType.blocked:
        return Icons.block;
    }
  }

  String get defaultTitle {
    switch (widget.event.type) {
      case CalendarEventType.vacation:
        return 'Ferie';

      case CalendarEventType.sick:
        return 'Malattia';

      case CalendarEventType.breakTime:
        return 'Pausa';

      case CalendarEventType.meeting:
        return 'Riunione';

      case CalendarEventType.blocked:
        return 'Bloccato';
    }
  }

  String time(DateTime d) {
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: MouseRegion(
          cursor: _dragging
              ? SystemMouseCursors.grabbing
              : SystemMouseCursors.grab,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onPanStart: (_) {
              setState(() => _dragging = true);
              widget.onDragStart?.call();
            },
            onPanUpdate: (details) {
              widget.onDragUpdate?.call(
                Offset(
                  details.delta.dx,
                  details.globalPosition.dy,
                ),
              );
            },
            onPanEnd: (_) {
              setState(() => _dragging = false);
              widget.onDragEnd?.call();
            },
            child: AnimatedScale(
              duration: const Duration(milliseconds: 120),
              scale: _pressed
                  ? .97
                  : _dragging
                      ? 1.03
                      : 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(bottom: 2),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.isValid
                      ? color.withValues(
                          alpha: _hover ? .20 : .14,
                        )
                      : Colors.red.withValues(
                          alpha: .22,
                        ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: color,
                    width: widget.isValid ? 2 : 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: _dragging
                          ? 18
                          : _hover
                              ? 12
                              : 6,
                      offset: Offset(
                        0,
                        _dragging ? 8 : 2,
                      ),
                      color: Colors.black.withValues(
                        alpha: _dragging ? .22 : .08,
                      ),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          icon,
                          color: color,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.event.title.isEmpty
                                    ? defaultTitle
                                    : widget.event.title,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${time(widget.event.startDate)} - ${time(widget.event.endDate)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              if (widget.event.note.isNotEmpty &&
                                  height > 70) ...[
                                const SizedBox(height: 6),
                                Expanded(
                                  child: Text(
                                    widget.event.note,
                                    overflow:
                                        TextOverflow.fade,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: GestureDetector(
                        behavior:
                            HitTestBehavior.opaque,
                        onPanStart: (_) {
                          setState(
                            () => _resizing = true,
                          );
                          widget.onResizeStart?.call();
                        },
                        onPanUpdate: (details) {
                          widget.onResizeUpdate?.call(
                            Offset(
                              details.delta.dx,
                              details.globalPosition.dy,
                            ),
                          );
                        },
                        onPanEnd: (_) {
                          setState(
                            () => _resizing = false,
                          );
                          widget.onResizeEnd?.call();
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors
                              .resizeUpDown,
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 150,
                            ),
                            width:
                                _resizing ? 22 : 18,
                            height:
                                _resizing ? 10 : 8,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius:
                                  BorderRadius.circular(
                                50,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius:
                                      _resizing
                                          ? 8
                                          : 0,
                                  color: Colors.black
                                      .withValues(
                                    alpha: .20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
