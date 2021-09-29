import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  var postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SocialCubit.get(context).userModel!=null?Scaffold(
          appBar:
              defaultAppBar(context: context, title: 'Create Post', actions: [
            TextButton(
              onPressed: () {
                if (SocialCubit.get(context).postImage != null) {
                  SocialCubit.get(context).uploadPostImage(
                      text: postController.text,
                      dateTime: DateTime.now().toString());

                } else {
                  SocialCubit.get(context).createPost(
                      text: postController.text,
                      dateTime: DateTime.now().toString());
                }
              },
              child: Text('POST'),
            )
          ]),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState) SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                          SocialCubit.get(context).userModel!.image as String),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('${SocialCubit.get(context).userModel!.name}'),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: postController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Post can\'t be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'What is in your mind now?',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (SocialCubit.get(context).postImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image(
                          image: FileImage(SocialCubit.get(context).postImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(icon: CircleAvatar(child: Icon(Icons.close)),onPressed: (){SocialCubit.get(context).clearPostImage();},)
                    ],
                  ),
                if (SocialCubit.get(context).postImage != null)
                  SizedBox(
                    height: 10,
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Add photo')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('# Tags'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ):Center(child:CircularProgressIndicator());
      },
    );
  }
}
