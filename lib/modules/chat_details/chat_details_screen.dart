import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/social_model/chat_model.dart';
import 'package:social_app/models/social_model/user_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel userModel;

  ChatDetailsScreen(this.userModel);

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(userModel.uId);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider('${userModel.image}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('${userModel.name}'),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          if (SocialCubit.get(context)
                                  .messages[index]
                                  .senderUId ==
                              SocialCubit.get(context).userModel!.uId) {
                            return buildMyMessages(
                                SocialCubit.get(context).messages[index]);
                          } else {
                            return buildMessages(
                                SocialCubit.get(context).messages[index]);
                          }
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 15,
                          );
                        },
                        itemCount: SocialCubit.get(context).messages.length),
                  ),
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: textController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type your message here',
                            ),
                          ),
                        ),
                        if (SocialCubit.get(context).chatMessageImage == null)
                          IconButton(
                            icon: Icon(IconBroken.Camera),
                            onPressed: () {
                              SocialCubit.get(context).getChatMessageImage();
                            },
                            splashRadius: 25,
                          ),
                        if (SocialCubit.get(context).chatMessageImage != null)
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image(
                                  image: FileImage(SocialCubit.get(context)
                                      .chatMessageImage!),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                onPressed: () {
                                  SocialCubit.get(context).clearChatImage();
                                },
                              ),
                            ],
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 50,
                          child: MaterialButton(
                            minWidth: 1,
                            color: defaultColor,
                            onPressed: () {
                              SocialCubit.get(context).sendMessage(
                                  receiverUId: userModel.uId,
                                  text: textController.text,
                                  dateTime: DateTime.now().toString());
                              textController.text = "";
                            },
                            child: Icon(IconBroken.Send),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildMyMessages(ChatModel model) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
          color: defaultColor.withOpacity(0.2),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.image != "")
              Container(
                width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(   fit: BoxFit.fill,imageUrl: '${model.image}')),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 90, minHeight: 38),
                    child: Text('${model.text}')),
                Text(
                  '${model.dateTime.substring(0, 19)}',
                  style: TextStyle(fontSize: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessages(ChatModel model) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: Colors.grey[300]),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage( fit: BoxFit.fill,imageUrl: '${model.image}'),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 90, minHeight: 35),
                    child: Text('${model.text}')),
                Text(
                  '${model.dateTime.substring(0, 19)}',
                  style: TextStyle(fontSize: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
