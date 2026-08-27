import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../review_providers.dart';
import '../widgets/review_card.dart';


class EmployeeReviewsPage extends ConsumerStatefulWidget{
  const EmployeeReviewsPage({
    super.key,
    required this.salonId,
    required this.employeeId,
    required this.employeeName,
  });

  final String salonId;
  final String employeeId;
  final String employeeName;


  @override
  ConsumerState<EmployeeReviewsPage> createState()=>
      _EmployeeReviewsPageState();
}



class _EmployeeReviewsPageState
    extends ConsumerState<EmployeeReviewsPage>{


  @override
  void initState(){

    super.initState();

    Future.microtask(
      _loadReviews,
    );
  }



  Future<void> _loadReviews()async{

    await ref
        .read(reviewControllerProvider)
        .loadEmployeeReviews(
      salonId:widget.salonId,
      employeeId:widget.employeeId,
    );
  }



  @override
  Widget build(BuildContext context){

    final controller=
    ref.watch(reviewControllerProvider);


    final reviews=
        controller.reviews;



    return Scaffold(

      appBar:AppBar(

        title:Text(
          widget.employeeName.isEmpty
              ?'Recensioni operatore'
              :widget.employeeName,
        ),
      ),



      body:

      controller.isLoading

          ?const Center(
        child:CircularProgressIndicator(),
      )


          :controller.error!=null

          ?Center(

        child:Column(

          mainAxisSize:
          MainAxisSize.min,

          children:[

            Text(
              controller.error!,
              textAlign:
              TextAlign.center,
            ),

            const SizedBox(
              height:12,
            ),


            ElevatedButton(

              onPressed:
              _loadReviews,

              child:
              const Text(
                'Riprova',
              ),
            ),
          ],
        ),
      )


          :reviews.isEmpty

          ?const Center(

        child:
        Text(
          'Nessuna recensione disponibile',
        ),
      )


          :RefreshIndicator(

        onRefresh:
        _loadReviews,


        child:ListView.builder(

          padding:
          const EdgeInsets.all(16),


          itemCount:
          reviews.length,


          itemBuilder:
              (context,index){

            return ReviewCard(
              review:
              reviews[index],
            );
          },
        ),
      ),
    );
  }
}