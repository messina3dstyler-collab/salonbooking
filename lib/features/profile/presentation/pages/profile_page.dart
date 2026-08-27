import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/theme.dart';
import '../../../home/home_providers.dart';

import 'edit_profile_page.dart';
import 'package:go_router/go_router.dart';


class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});


  Future<void> _logout(
      BuildContext context,
      )async{

    final confirm =
    await showDialog<bool>(
      context: context,
      builder: (_) =>
          AlertDialog(
            title:
            const Text(
              'Uscire dall\'account?',
            ),

            content:
            const Text(
              'Vuoi davvero effettuare il logout?',
            ),

            actions:[

              TextButton(
                onPressed:(){
                  Navigator.pop(
                    context,
                    false,
                  );
                },
                child:
                const Text(
                  'No',
                ),
              ),


              ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.red,
                ),

                onPressed:(){
                  Navigator.pop(
                    context,
                    true,
                  );
                },

                child:
                const Text(
                  'Esci',
                ),
              ),

            ],
          ),
    );


    if(confirm!=true)return;


    await FirebaseAuth
        .instance
        .signOut();


    if(!context.mounted)return;


    context.go('/login');
  }



  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ){

    final controller =
    ref.watch(
      homeControllerProvider,
    );

    final user =
        controller.user;


    return Scaffold(

      backgroundColor:
      AppColors.background,


      appBar:
      AppBar(
        title:
        const Text(
          "Profilo",
        ),
      ),


      body:
      user == null

          ?

      const Center(
        child:
        CircularProgressIndicator(),
      )


          :

      SingleChildScrollView(

        padding:
        const EdgeInsets.all(
          AppSpacing.xl,
        ),


        child:
        Column(

          children:[


            CircleAvatar(

              radius:55,

              backgroundColor:
              AppColors.primary,


              child:
              Text(

                user.name.isNotEmpty
                    ? user.name[0]
                    .toUpperCase()
                    : "?",


                style:
                const TextStyle(

                  fontSize:38,

                  color:
                  Colors.white,

                  fontWeight:
                  FontWeight.bold,

                ),
              ),
            ),


            const SizedBox(
              height:
              AppSpacing.xl,
            ),


            Text(
              user.name,
              style:
              AppTextStyles.titleLarge,
            ),


            const SizedBox(
              height:6,
            ),


            Text(
              user.email,
              style:
              AppTextStyles.body,
            ),


            const SizedBox(
              height:
              AppSpacing.xxl,
            ),



            Card(
              child:
              ListTile(

                leading:
                const Icon(
                  Icons.person,
                ),

                title:
                const Text(
                  "Nome",
                ),

                subtitle:
                Text(
                  user.name,
                ),
              ),
            ),



            const SizedBox(
              height:
              AppSpacing.md,
            ),



            Card(
              child:
              ListTile(

                leading:
                const Icon(
                  Icons.email,
                ),

                title:
                const Text(
                  "Email",
                ),

                subtitle:
                Text(
                  user.email,
                ),
              ),
            ),



            const SizedBox(
              height:
              AppSpacing.md,
            ),



            Card(
              child:
              ListTile(

                leading:
                const Icon(
                  Icons.phone,
                ),

                title:
                const Text(
                  "Telefono",
                ),

                subtitle:
                Text(
                  user.phone.isEmpty
                      ? "Non inserito"
                      : user.phone,
                ),
              ),
            ),



            const SizedBox(
              height:
              AppSpacing.xxl,
            ),



            SizedBox(

              width:
              double.infinity,


              child:
              ElevatedButton.icon(

                icon:
                const Icon(
                  Icons.edit,
                ),


                label:
                const Text(
                  "Modifica profilo",
                ),


                onPressed:(){

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:(_)=>
                      const EditProfilePage(),
                    ),
                  );

                },

              ),
            ),



            const SizedBox(
              height:
              AppSpacing.md,
            ),



            SizedBox(

              width:
              double.infinity,


              child:
              ElevatedButton.icon(

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.red,
                  foregroundColor:
                  Colors.white,
                ),


                icon:
                const Icon(
                  Icons.logout,
                ),


                label:
                const Text(
                  "Logout",
                ),


                onPressed:(){

                  _logout(
                    context,
                  );

                },

              ),
            ),

          ],
        ),
      ),
    );
  }
}