import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;


        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              TextButton(
                onPressed: () {
                  SocialCubit.get(context).updateUser(
                      name: SocialCubit.get(context).nameController.text,
                      phone: SocialCubit.get(context).phoneController.text,
                      bio: SocialCubit.get(context).bioController.text);
                },
                child: Text('UPDATE'),
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  if (state is SocialUpdateUserLoadingState)
                    LinearProgressIndicator(),
                  if (state is SocialUpdateUserLoadingState)
                    SizedBox(
                      height: 10,
                    ),
                  Container(
                    height: 210,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                width: double.infinity,
                                height: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? CachedNetworkImageProvider(
                                      '${userModel!.cover}',)
                                        : FileImage(coverImage) as ImageProvider,
                                    fit: BoxFit.cover,
                                ),
                                ),
                              ),
                              Material(
                                type: MaterialType.transparency,
                                borderRadius: BorderRadius.circular(25),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                    radius: 20,
                                    child: Icon(
                                      IconBroken.Camera,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundImage: profileImage == null
                                    ? CachedNetworkImageProvider(
                                  '${userModel!.image}',
                                )
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            Material(
                              type: MaterialType.transparency,
                              borderRadius: BorderRadius.circular(25),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    IconBroken.Camera,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: SocialCubit.get(context).nameController,
                      label: 'Name',
                      keyType: TextInputType.text,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Your name can\'t be empty';
                        }
                        return null;
                      },
                      prefix: IconBroken.User),
                  SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                      controller: SocialCubit.get(context).bioController,
                      label: 'Bio',
                      keyType: TextInputType.text,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Your Bio can\'t be empty';
                        }
                        return null;
                      },
                      prefix: IconBroken.Info_Circle),
                  SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                      controller: SocialCubit.get(context).phoneController,
                      label: 'Phone',
                      keyType: TextInputType.phone,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Your phone can\'t be empty';
                        }
                        return null;
                      },
                      prefix: Icons.phone),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
