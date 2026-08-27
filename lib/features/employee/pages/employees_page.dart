import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';

import '../../salon/models/salon_model.dart';
import '../../service/models/service_model.dart';

import '../employee_providers.dart';
import '../widgets/employee_card.dart';

class EmployeesPage extends ConsumerStatefulWidget {

  const EmployeesPage({
    super.key,
    required this.salonId,
    required this.salon,
    required this.service,
  });


  final String salonId;
  final SalonModel salon;
  final ServiceModel service;



  @override
  ConsumerState<EmployeesPage> createState() =>
      _EmployeesPageState();
}



class _EmployeesPageState
    extends ConsumerState<EmployeesPage>{


  @override
  void initState(){

    super.initState();

    Future.microtask(
      _loadEmployees,
    );
  }



  Future<void> _loadEmployees() async {

    await ref
        .read(employeeControllerProvider)
        .loadEmployees(
      widget.salonId,
    );
  }



  @override
  Widget build(BuildContext context){

    final controller =
    ref.watch(employeeControllerProvider);



    final employees =
    controller.employees
        .where(
          (e)=>e.active,
    )
        .toList();



    return Scaffold(

      backgroundColor:
      AppColors.background,


      appBar:AppBar(

        title:
        const Text(
          'Scegli operatore',
        ),
      ),



      body:

      controller.isLoading

          ? const Center(
        child:CircularProgressIndicator(),
      )


          :

      employees.isEmpty

          ? const Center(
        child:Text(
          'Nessun operatore disponibile',
        ),
      )


          :

      RefreshIndicator(

        onRefresh:_loadEmployees,


        child:ListView.builder(

          padding:
          const EdgeInsets.all(
            AppSpacing.xl,
          ),


          itemCount:
          employees.length,


          itemBuilder:(context,index){

            return EmployeeCard(
              employee: employees[index],
              salon: widget.salon,
              service: widget.service,
            );
          },
        ),
      ),
    );
  }
}