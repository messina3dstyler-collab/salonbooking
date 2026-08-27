import 'package:flutter/material.dart';

import '../../salon/models/salon_model.dart';
import '../../service/models/service_model.dart';

import 'package:salon_booking/features/employee/models/employee_model.dart';
import '../pages/employee_profile_page.dart';
import '../../employee/pages/employee_calendar_page.dart';

class EmployeeCard extends StatelessWidget {

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.salon,
    required this.service,
  });



  final EmployeeModel employee;
  final SalonModel salon;
  final ServiceModel service;



  @override
  Widget build(BuildContext context){

    return Card(

      margin:
      const EdgeInsets.symmetric(
        vertical:6,
      ),


      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(16),
      ),


      child:InkWell(

        borderRadius:
        BorderRadius.circular(16),


        onTap:(){

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeProfilePage(
                employee: employee,
                salon: salon,
                service: service,
              ),
            ),
          );

        },



        child:Padding(

          padding:
          const EdgeInsets.all(12),


          child:Row(

            children:[


              CircleAvatar(

                radius:28,


                backgroundImage:
                employee.photoUrl.isEmpty
                    ?null
                    :NetworkImage(
                  employee.photoUrl,
                ),



                child:
                employee.photoUrl.isEmpty

                    ?Text(
                  employee.name.isEmpty
                      ?'?'
                      :employee.name[0]
                      .toUpperCase(),
                )

                    :null,
              ),



              const SizedBox(
                width:12,
              ),



              Expanded(

                child:Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,


                  children:[


                    Text(

                      employee.name.isEmpty
                          ?'Operatore'
                          :employee.name,


                      style:
                      const TextStyle(

                        fontWeight:
                        FontWeight.bold,

                        fontSize:16,
                      ),
                    ),



                    if(employee.specialization.isNotEmpty)

                      Padding(

                        padding:
                        const EdgeInsets.only(
                          top:4,
                        ),

                        child:Text(
                          employee.specialization,
                        ),
                      ),



                    const SizedBox(
                      height:6,
                    ),



                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              employee.rating.toStringAsFixed(1),
                            ),

                            const SizedBox(width: 8),

                            Text(
                              '${employee.reviewCount} recensioni',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [

                            FilledButton.tonalIcon(
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EmployeeCalendarPage(
                                      employee: employee,
                                    ),
                                  ),
                                );

                              },
                              icon: const Icon(Icons.calendar_month),
                              label: const Text('Agenda'),
                            ),

                            const SizedBox(width: 8),

                            OutlinedButton.icon(
                              onPressed: () {
                                // nel prossimo step aprirà la modifica dipendente
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Modifica'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),



              PopupMenuButton<String>(
                tooltip: 'Azioni',
                onSelected: (value) {

                  switch (value) {

                    case 'disable':

                    // lo collegheremo nel prossimo step

                      break;

                  }

                },

                itemBuilder: (context) => const [

                  PopupMenuItem(
                    value: 'disable',
                    child: Row(
                      children: [

                        Icon(Icons.block),

                        SizedBox(width: 8),

                        Text('Disattiva'),

                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}