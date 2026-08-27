import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../app/theme/theme.dart';
import '../../appointment_providers.dart';
import '../../controller/appointment_controller.dart';
import '../widgets/appointment_card.dart';

class AppointmentCalendarPage extends ConsumerStatefulWidget{
  const AppointmentCalendarPage({super.key});

  @override
  ConsumerState<AppointmentCalendarPage> createState()=>_AppointmentCalendarPageState();
}

class _AppointmentCalendarPageState extends ConsumerState<AppointmentCalendarPage>{
  DateTime _selectedDay=DateTime.now();
  DateTime _focusedDay=DateTime.now();

  @override
  void initState(){
    super.initState();

    Future.microtask((){
      ref.read(appointmentControllerProvider).loadAppointments();
    });
  }

  List<DateTime> _appointmentDays(List appointments){
    return appointments.map((a){
      final date=a.appointmentDate;

      return DateTime(
        date.year,
        date.month,
        date.day,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context){
    final controller=ref.watch(appointmentControllerProvider);

    final days=_appointmentDays(
      controller.appointments,
    );

    return Scaffold(
      backgroundColor:AppColors.background,
      appBar:AppBar(
        title:const Text(
          'Calendario appuntamenti',
        ),
      ),
      body:Column(
        children:[
          Card(
            margin:const EdgeInsets.all(
              AppSpacing.lg,
            ),
            child:TableCalendar(
              locale:'it_IT',
              focusedDay:_focusedDay,
              firstDay:DateTime.utc(2020),
              lastDay:DateTime.utc(2035),
              selectedDayPredicate:(day){
                return isSameDay(
                  day,
                  _selectedDay,
                );
              },
              onDaySelected:(selected,focused){
                setState((){
                  _selectedDay=selected;
                  _focusedDay=focused;
                });
              },
              eventLoader:(day){
                final normalized=DateTime(
                  day.year,
                  day.month,
                  day.day,
                );

                return days.contains(normalized)
                    ?[true]
                    :[];
              },
              calendarStyle:const CalendarStyle(
                markerDecoration:BoxDecoration(
                  color:AppColors.primary,
                  shape:BoxShape.circle,
                ),
              ),
            ),
          ),
          Expanded(
            child:_list(controller),
          ),
        ],
      ),
    );
  }

  Widget _list(AppointmentController controller){

    final filtered=controller.appointments.where((a){
      return isSameDay(
        a.appointmentDate,
        _selectedDay,
      );
    }).toList();

    if(controller.isLoading){
      return const Center(
        child:CircularProgressIndicator(),
      );
    }

    if(controller.error!=null){
      return Center(
        child:Text(
          controller.error!,
        ),
      );
    }

    if(filtered.isEmpty){
      return const Center(
        child:Text(
          'Nessun appuntamento per questo giorno',
        ),
      );
    }

    return ListView.builder(
      padding:const EdgeInsets.all(
        AppSpacing.lg,
      ),
      itemCount:filtered.length,
      itemBuilder:(context,index){
        return AppointmentCard(
          appointment:filtered[index],
        );
      },
    );
  }
}