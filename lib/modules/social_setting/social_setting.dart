import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SocialSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialCubit.get(context).userModel;
        return model != null
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: 210,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                width: double.infinity,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: model.cover!,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),),
                          ),
                          CircleAvatar(
                            radius: 44,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child:CachedNetworkImage(
                              imageUrl: model.image!,
                              imageBuilder: (context, imageProvider) => Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state is SocialGetUserLoadingState)
                      CircularProgressIndicator(),
                    Text(
                      '${model.name}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${model.bio}',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'Posts',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'Photos',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'Followers',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'Followings',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                  onPressed: () {}, child: Text('Add Photos'))),
                          SizedBox(width: 10),
                          OutlinedButton(
                              onPressed: () {
                                navigateTo(context, EditProfileScreen());
                              },
                              child: Icon(IconBroken.Edit))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: (){
                          FirebaseMessaging.instance.subscribeToTopic('announcement');
                        }, child: Text('Subscribe'))),
                        Expanded(child: OutlinedButton(onPressed: (){
                          FirebaseMessaging.instance.unsubscribeFromTopic('announcement');
                        }, child: Text('Unsubscribe'))),
                      ],
                    )
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
