import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/social_model/user_model.dart';
import 'package:social_app/shared/components/components.dart';

class SocialChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
       return ListView.separated(itemBuilder: (context,index){
          return buildChatItem(SocialCubit.get(context).users[index],context);

       }, separatorBuilder:(context,index){
         return Container(
           height: 1,
           width: double.infinity,
           color: Colors.grey[300],
         );
       }, itemCount: SocialCubit.get(context).users.length);
      },
    );
  }
  Widget buildChatItem(SocialUserModel model,BuildContext context){
    return InkWell(
      onTap: (){
        SocialCubit.get(context).messages=[];
        navigateTo(context, ChatDetailsScreen(model));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: '${model.image}',
              imageBuilder: (context, imageProvider) => Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(model.name),
            ),
          ],
        ),
      ),
    );
  }
}
