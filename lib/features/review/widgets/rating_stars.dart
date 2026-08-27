import 'package:flutter/material.dart';


class RatingStars extends StatelessWidget{
  const RatingStars({
    super.key,
    required this.rating,
    this.onChanged,
    this.size=28,
    this.color=Colors.amber,
  });


  final double rating;
  final ValueChanged<double>? onChanged;
  final double size;
  final Color color;


  bool get selectable=>onChanged!=null;


  @override
  Widget build(BuildContext context){

    return Row(

      mainAxisSize:
      MainAxisSize.min,

      children:
      List.generate(

        5,

            (index){

          final value=index+1.0;

          return IconButton(

            padding:
            EdgeInsets.zero,

            constraints:
            const BoxConstraints(),

            onPressed:
            selectable
                ?()=>onChanged!(value)
                :null,


            icon:Icon(

              value<=rating
                  ?Icons.star
                  :Icons.star_border,

              size:size,

              color:color,
            ),
          );
        },
      ),
    );
  }
}