import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../review_providers.dart';
import '../widgets/review_card.dart';


class UserReviewsPage extends ConsumerStatefulWidget{
  const UserReviewsPage({
    super.key,
    required this.salonId,
    required this.userId,
  });

  final String salonId;
  final String userId;


  @override
  ConsumerState<UserReviewsPage> createState()=>_UserReviewsPageState();
}


class _UserReviewsPageState extends ConsumerState<UserReviewsPage>{

  @override
  void initState(){
    super.initState();
    Future.microtask(_loadReviews);
  }


  Future<void> _loadReviews()async{
    await ref
        .read(reviewControllerProvider)
        .loadUserReviews(
      salonId:widget.salonId,
      userId:widget.userId,
    );
  }


  @override
  Widget build(BuildContext context){

    final controller=ref.watch(reviewControllerProvider);
    final reviews=controller.reviews;


    return Scaffold(
      appBar:AppBar(
        title:const Text('Le mie recensioni'),
      ),

      body:controller.isLoading

          ?const Center(
        child:CircularProgressIndicator(),
      )

          :controller.error!=null

          ?Center(
        child:Column(
          mainAxisSize:MainAxisSize.min,
          children:[
            Text(
              controller.error!,
              textAlign:TextAlign.center,
            ),
            const SizedBox(height:12),
            ElevatedButton(
              onPressed:_loadReviews,
              child:const Text('Riprova'),
            ),
          ],
        ),
      )

          :reviews.isEmpty

          ?const Center(
        child:Text(
          'Non hai ancora lasciato recensioni',
        ),
      )

          :RefreshIndicator(
        onRefresh:_loadReviews,

        child:ListView.builder(
          padding:const EdgeInsets.all(16),
          itemCount:reviews.length,

          itemBuilder:(context,index){
            return ReviewCard(
              review:reviews[index],
            );
          },
        ),
      ),
    );
  }
}