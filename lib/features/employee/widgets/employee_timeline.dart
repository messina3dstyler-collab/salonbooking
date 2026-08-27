import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salon_booking/features/employee/models/employee_model.dart';

import '../models/employee_calendar_model.dart';
import 'employee_current_time_indicator.dart';
import 'employee_event_block.dart';

class EmployeeTimeline extends StatefulWidget {
  const EmployeeTimeline({
    super.key,
    required this.employee,
    required this.events,
    required this.onEventTap,
    required this.onEventMoved,
    required this.isEventValid,
  });

  final EmployeeModel employee;
  final List<EmployeeCalendarModel> events;
  final ValueChanged<EmployeeCalendarModel> onEventTap;
  final ValueChanged<EmployeeCalendarModel> onEventMoved;
  final bool Function(EmployeeCalendarModel)
  isEventValid;

  static const double hourHeight = 80;

  @override
  State<EmployeeTimeline> createState() =>
      _EmployeeTimelineState();
}

class _EmployeeTimelineState
    extends State<EmployeeTimeline> {

  final ScrollController _scrollController =
      ScrollController();

  Timer? _timer;
  Timer? _autoScrollTimer;

  EmployeeCalendarModel? _draggingEvent;
  EmployeeCalendarModel? _dragPreview;
  EmployeeCalendarModel? _resizingEvent;
  EmployeeCalendarModel? _resizePreview;

  double _dragPixels = 0;
  double _resizePixels = 0;
  double _pointerY = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentHour();
    });

    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentHour() {
    final now = DateTime.now();

    final minutes =
        now.hour * 60 +
        now.minute -
        90;

    final offset =
        (minutes *
                EmployeeTimeline.hourHeight /
                60)
            .clamp(
      0.0,
      EmployeeTimeline.hourHeight * 24,
    );

    _scrollController.jumpTo(offset);
  }
  void _autoScroll() {
    if(!mounted||!_scrollController.hasClients){
      return;
    }

    const edge=120.0;
    const maxSpeed=28.0;

    final pos=_scrollController.position;
    final viewport=pos.viewportDimension;

    double delta=0;

    if(_pointerY>viewport-edge){
      final factor=((_pointerY-(viewport-edge))/edge)
          .clamp(0.0,1.0);

      delta=maxSpeed*factor;
    }else if(_pointerY<edge){
      final factor=((edge-_pointerY)/edge)
          .clamp(0.0,1.0);

      delta=-maxSpeed*factor;
    }

    if(delta==0){
      return;
    }

    _scrollController.jumpTo(
      (pos.pixels+delta)
          .clamp(0.0,pos.maxScrollExtent),
    );

    if(_draggingEvent!=null){
      _updateDrag(
        Offset(0,delta),
        pointerY:_pointerY,
      );
    }

    if(_resizingEvent!=null){
      _updateResize(
        Offset(0,delta),
        pointerY:_pointerY,
      );
    }
  }
  int _snapMinutes(int minutes){
    const grid=15;
    const magnet=5;

    final snaps=<int>[
      ((minutes/grid).round())*grid,

      widget.employee.startHour*60,
      widget.employee.endHour*60,
    ];

    if(widget.employee.hasBreak){
      snaps.addAll([
        widget.employee.breakStart,
        widget.employee.breakEnd,
      ]);
    }

    var result=minutes;
    var distance=1<<30;

    for(final snap in snaps){
      final d=(minutes-snap).abs();
      if(d<distance&&d<=magnet){
        distance=d;
        result=snap;
      }
    }

    return result;
  }
  void _startDrag(EmployeeCalendarModel event){
    _autoScrollTimer?.cancel();
    _autoScrollTimer=Timer.periodic(
      const Duration(milliseconds:16),
          (_)=>_autoScroll(),
    );

    setState(() {
      _draggingEvent=event;
      _dragPreview=event;
      _dragPixels=0;
    });
  }

  void _updateDrag(
      Offset delta, {
        double? pointerY,
      }) {
    if(_draggingEvent==null||_dragPreview==null){
      return;
    }

    _dragPixels+=delta.dy;
    _pointerY=delta.dy;

    final minutes=(_dragPixels*60/
        EmployeeTimeline.hourHeight).round();

    final snapped=_snapMinutes(minutes);

    setState(() {
      _dragPreview =
          _draggingEvent!.moveByMinutes(snapped);
    });
  }

  void _endDrag(){
    _autoScrollTimer?.cancel();

    if(_dragPreview!=null&&
        widget.isEventValid(_dragPreview!)){
      widget.onEventMoved(_dragPreview!);
    }

    setState(() {
      _draggingEvent=null;
      _dragPreview=null;
      _dragPixels=0;
    });
  }
  void _startResize(EmployeeCalendarModel event){
    _autoScrollTimer?.cancel();
    _autoScrollTimer=Timer.periodic(
      const Duration(milliseconds:16),
          (_)=>_autoScroll(),
    );

    setState(() {
      _resizingEvent=event;
      _resizePreview=event;
      _resizePixels=0;
    });
  }

  void _updateResize(
      Offset delta, {
        double? pointerY,
      }) {
    if(_resizingEvent==null||_resizePreview==null){
      return;
    }

    _resizePixels+=delta.dy;
    _pointerY=delta.dy;

    final minutes = (_resizePixels*60/
        EmployeeTimeline.hourHeight).round();

    final snapped=_snapMinutes(minutes);

    final duration =
        _resizingEvent!.duration.inMinutes + snapped;

    if(duration<15){
      return;
    }

    setState(() {
      _resizePreview =
          _resizingEvent!.resizeToMinutes(duration);
    });
  }

  void _endResize(){
    _autoScrollTimer?.cancel();

    if(_resizePreview!=null&&
        widget.isEventValid(_resizePreview!)){
      widget.onEventMoved(_resizePreview!);
    }

    setState(() {
      _resizingEvent=null;
      _resizePreview=null;
      _resizePixels=0;
    });
  }

  bool _overlap(
    EmployeeCalendarModel a,
    EmployeeCalendarModel b,
  ) {
    return a.startDate.isBefore(b.endDate) &&
        b.startDate.isBefore(a.endDate);
  }

  List<_EventLayout> _calculateLayout() {
    final events = [...widget.events];

    events.sort(
      (a, b) =>
          a.startDate.compareTo(
        b.startDate,
      ),
    );

    final layouts = <_EventLayout>[];

    final visited = <String>{};

    for (final event in events) {
      if (visited.contains(event.id)) {
        continue;
      }

      final cluster =
          <EmployeeCalendarModel>[];

      void visit(
        EmployeeCalendarModel current,
      ) {
        if (visited.contains(current.id)) {
          return;
        }

        visited.add(current.id);
        cluster.add(current);

        for (final other in events) {
          if (_overlap(current, other)) {
            visit(other);
          }
        }
      }

      visit(event);
      cluster.sort(
        (a, b) =>
            a.startDate.compareTo(
          b.startDate,
        ),
      );

      final columns =
          <List<EmployeeCalendarModel>>[];

      for (final event in cluster) {

        bool inserted = false;

        for (
          var i = 0;
          i < columns.length;
          i++
        ) {

          final last = columns[i].last;

          if (!last.endDate.isAfter(
            event.startDate,
          )) {

            columns[i].add(event);
            inserted = true;
            break;
          }
        }
        if (!inserted) {
          columns.add([event]);
        }
      }
      for (
        var column = 0;
        column < columns.length;
        column++
      ) {

        for (final event in columns[column]) {

          layouts.add(
            _EventLayout(
              event: event,
              column: column,
              columns: columns.length,
            ),
          );
        }
      }

    }
    return layouts;
  }

  List<Widget> _buildEventWidgets(
    BuildContext context,
  ) {

    final layouts =
        _calculateLayout();
    const leftMargin = 70.0;
    const rightMargin = 12.0;
    final availableWidth =
        MediaQuery.of(context).size.width -
            leftMargin -
            rightMargin;

    return layouts.map((layout) {

      final width =
          availableWidth /
              layout.columns;

      final dragging =
          _draggingEvent?.id == layout.event.id;

      final resizing =
          _resizingEvent?.id == layout.event.id;

      final active =
          dragging || resizing;

      final preview =
      dragging
          ? (_dragPreview ?? layout.event)
          : resizing
          ? (_resizePreview ?? layout.event)
          : layout.event;

      final valid =
      active
          ? widget.isEventValid(preview)
          : true;

      final top=((preview.startDate.hour*60)+
          preview.startDate.minute)*
          EmployeeTimeline.hourHeight/60;

      final height=preview.duration.inMinutes*
          EmployeeTimeline.hourHeight/60;

      return Positioned(
        left:leftMargin+width*layout.column,
        width:width-6,
        top:top,
        height:height<40?40:height,
        child:AnimatedOpacity(
          duration:const Duration(milliseconds:80),
          opacity:dragging||resizing?0.90:1,
          child:EmployeeEventBlock(
            event:preview,
            hourHeight:EmployeeTimeline.hourHeight,
            isValid: valid,
            onTap:()=>widget.onEventTap(layout.event),
            onDragStart:()=>_startDrag(layout.event),
            onDragUpdate:_updateDrag,
            onDragEnd:_endDrag,
            onResizeStart:(){
              _startResize(layout.event);
            },
            onResizeUpdate:_updateResize,
            onResizeEnd:_endResize,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(

      child: SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          height:
              EmployeeTimeline.hourHeight * 24,
          child: Stack(
            children: [

              /// Timeline oraria
              Column(
                children: List.generate(
                  24,
                  (hour) => SizedBox(
                    height:
                        EmployeeTimeline.hourHeight,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 58,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(
                              top: 2,
                              right: 8,
                            ),
                            child: Text(
                              '${hour.toString().padLeft(2, '0')}:00',
                              textAlign: TextAlign.end,
                              style:
                                  const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Divider(
                            height:
                                EmployeeTimeline.hourHeight,
                            color:
                                Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Pausa pranzo
              if (widget.employee.hasBreak)

                Positioned(
                  left: 70,
                  right: 12,
                  top:
                      widget.employee.breakStart *
                          EmployeeTimeline.hourHeight /
                          60,
                  height:
                      (widget.employee.breakEnd -
                              widget.employee.breakStart) *
                          EmployeeTimeline.hourHeight /
                          60,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.grey.withValues(
                          alpha: .10,
                        ),

                        borderRadius:
                            BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              Colors.grey.shade400,
                        ),

                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [

                            const Icon(
                              Icons.restaurant,
                              color: Colors.grey,
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            const Text(

                              'Pausa pranzo',

                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),

                            Text(

                              '${(widget.employee.breakStart ~/ 60).toString().padLeft(2, '0')}:'
                              '${(widget.employee.breakStart % 60).toString().padLeft(2, '0')}'
                              ' - '
                              '${(widget.employee.breakEnd ~/ 60).toString().padLeft(2, '0')}:'
                              '${(widget.employee.breakEnd % 60).toString().padLeft(2, '0')}',

                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              const EmployeeCurrentTimeIndicator(
                hourHeight:
                    EmployeeTimeline.hourHeight,
              ),

              ..._buildEventWidgets(context),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventLayout {
  const _EventLayout({
    required this.event,
    required this.column,
    required this.columns,

  });
  final EmployeeCalendarModel event;
  final int column;
  final int columns;
}