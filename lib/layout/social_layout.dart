import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/social_new_post/new_post.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import 'cubit/cubit.dart';
import 'cubit/social_states.dart';

class SocialLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {

        if(state is SocialNewPostState){
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(SocialCubit.get(context).titles[SocialCubit.get(context).currentIndex]),
            actions: [
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Notification)),
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Search))
            ],
          ),


          body: SocialCubit.get(context).screens[SocialCubit.get(context).currentIndex],


          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: SocialCubit.get(context).currentIndex,
            onTap: (value){
              SocialCubit.get(context).setIndex(value);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: 'HOME'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Chat), label: 'CHAT'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Paper), label: 'POST'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Message), label: 'MESSAGE'),
              BottomNavigationBarItem(icon: Icon(IconBroken.Setting), label: 'SETTING'),
            ],
          ),
        );
      },
    );
  }
}

// SocialCubit.get(context).userModel != null
//     ? Column(
//         children: [
//           if (!FirebaseAuth.instance.currentUser!.emailVerified)
//             Container(
//               color: Colors.amber.withOpacity(0.6),
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.info_outline),
//                         SizedBox(width: 10),
//                         Text('Please verify your Email'),
//                         Spacer(),
//                         TextButton(
//                             onPressed: SocialCubit.get(context)
//                                         .needRefresh ==
//                                     false
//                                 ? () {
//                                     // FirebaseAuth.instance.currentUser!.reload();
//                                     FirebaseAuth.instance.currentUser!
//                                         .sendEmailVerification()
//                                         .then((value) {
//                                       print(FirebaseAuth.instance
//                                           .currentUser!.email);
//                                       print(FirebaseAuth
//                                           .instance
//                                           .currentUser!
//                                           .emailVerified);
//                                       buildToast(
//                                           message:
//                                               'Please check your email',
//                                           state: ToastStates.SUCCESS);
//                                       SocialCubit.get(context)
//                                           .refreshAfterValidation();
//                                     }).catchError(
//                                       (error) {
//                                         print('your error is $error');
//                                         buildToast(
//                                             message:
//                                                 'Please try again later',
//                                             state: ToastStates.ERROR);
//                                       },
//                                     );
//                                   }
//                                 : null,
//                             child: Text('SEND')),
//                       ],
//                     ),
//                     if (SocialCubit.get(context).needRefresh == true)
//                       Row(
//                         children: [
//                           Text(
//                               'Press this button to refresh after validation'),
//                           TextButton(
//                             onPressed: () {
//                               SocialCubit.get(context)
//                                   .refreshAfterValidation();
//                             },
//                             child: Text('Refresh'),
//                           )
//                         ],
//                       )
//                   ],
//                 ),
//               ),
//             ),
//           SocialCubit.get(context).screens[SocialCubit.get(context).currentIndex],
//         ], //
//       )
//     : Center(
//         child: CircularProgressIndicator(), ),