import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../admin_providers.dart';
import '../../models/admin_appointment_model.dart';

class AppointmentDialog extends ConsumerStatefulWidget {
  const AppointmentDialog({
    super.key,
    required this.appointment,
    required this.onSave,
  });

  final AdminAppointmentModel appointment;
  final Future<void> Function(String status) onSave;

  @override
  ConsumerState<AppointmentDialog> createState() =>
      _AppointmentDialogState();
}

class _AppointmentDialogState
    extends ConsumerState<AppointmentDialog> {

  late String _status;
  String? _employeeId;
  bool _saving=false;

  @override
  void initState(){
    super.initState();

    _status=widget.appointment.status;
    _employeeId=widget.appointment.employeeId;

    Future.microtask((){
      ref
          .read(employeeControllerProvider)
          .loadEmployees(
        widget.appointment.salonId,
      );
    });
  }


  Future<void> _save() async {

    setState(() => _saving=true);

    try{

      if(_employeeId!=widget.appointment.employeeId){

        final employees=
            ref.read(employeeControllerProvider).employees;

        final employee=
            employees.where(
                  (e)=>e.id==_employeeId,
            ).firstOrNull;


        if(employee==null){
          throw Exception(
            'Dipendente non trovato',
          );
        }


        await ref
            .read(
          adminAppointmentsControllerProvider,
        )
            .updateEmployee(
          appointmentId:
          widget.appointment.id,
          employeeId:
          employee.id,
          employeeName:
          employee.name,
          employeePhone:
          employee.phone,
          employeeSpecialization:
          employee.specialization,
          employeeRating:
          employee.rating,
        );
      }


      await widget.onSave(
        _status,
      );


      if(mounted){
        Navigator.pop(context);
      }


    }catch(e){

      if(mounted){
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content:Text(
              'Errore aggiornamento appuntamento: $e',
            ),
          ),
        );
      }

    }finally{

      if(mounted){
        setState(() => _saving=false);
      }
    }
  }


  @override
  Widget build(BuildContext context){

    final employees=
        ref.watch(employeeControllerProvider)
            .employees;


    return AlertDialog(
      title:
      const Text(
        'Gestisci appuntamento',
      ),

      content:
      SizedBox(
        width:420,

        child:
        Column(
          mainAxisSize:
          MainAxisSize.min,

          children:[

            Text(
              widget.appointment.customerName.isEmpty
                  ? 'Cliente'
                  : widget.appointment.customerName,

              style:
              const TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),


            const SizedBox(height:8),


            Text(
              widget.appointment.serviceName.isEmpty
                  ? 'Servizio'
                  : widget.appointment.serviceName,
            ),


            const SizedBox(height:16),


            DropdownButtonFormField<String>(
              initialValue:_employeeId,

              decoration:
              const InputDecoration(
                labelText:'Dipendente',
                border:
                OutlineInputBorder(),
                prefixIcon:
                Icon(Icons.person),
              ),

              items:
              employees.map(
                    (employee){

                  return DropdownMenuItem(
                    value:
                    employee.id,

                    child:
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      mainAxisSize:
                      MainAxisSize.min,

                      children:[

                        Text(
                          employee.name,
                        ),

                        if(employee.specialization.isNotEmpty)

                          Text(
                            employee.specialization,

                            style:
                            const TextStyle(
                              fontSize:12,
                              color:Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ).toList(),


              onChanged:
                  (value){

                setState((){
                  _employeeId=value;
                });

              },
            ),


            const SizedBox(height:16),


            DropdownButtonFormField<String>(
              initialValue:_status,

              decoration:
              const InputDecoration(
                labelText:'Stato',
                border:
                OutlineInputBorder(),
              ),

              items:
              const [

                DropdownMenuItem(
                  value:'Confermata',
                  child:
                  Text('Confermata'),
                ),

                DropdownMenuItem(
                  value:'Completata',
                  child:
                  Text('Completata'),
                ),

                DropdownMenuItem(
                  value:'Annullata',
                  child:
                  Text('Annullata'),
                ),

              ],

              onChanged:
                  (value){

                if(value!=null){

                  setState((){
                    _status=value;
                  });

                }
              },
            ),
          ],
        ),
      ),


      actions:[

        TextButton(
          onPressed:
          _saving
              ? null
              : ()=>Navigator.pop(context),

          child:
          const Text(
            'Annulla',
          ),
        ),


        ElevatedButton(
          onPressed:
          _saving
              ? null
              : _save,

          child:
          _saving

              ? const SizedBox(
            width:18,
            height:18,

            child:
            CircularProgressIndicator(
              strokeWidth:2,
            ),
          )

              : const Text(
            'Salva',
          ),
        ),
      ],
    );
  }
}