import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/social_model/post_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SocialFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SocialCubit.get(context).posts.length > 0 &&
                SocialCubit.get(context).userModel != null
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 20,
                      margin: EdgeInsets.all(8),
                      child: Stack(alignment: Alignment.bottomRight, children: [
                        Image(
                          width: double.infinity,
                          image: CachedNetworkImageProvider(
                              'https://image.freepik.com/free-photo/pink-haired-woman-looks-thoughtfully-isolated-wall_197531-24150.jpg'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Communicate with friends',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white, fontSize: 13),
                          ),
                        )
                      ]),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // print(SocialCubit.get(context).posts[index].text);
                        return buildPostItem(
                            SocialCubit.get(context).posts[index],
                            context,
                            index);
                      },
                      itemCount: SocialCubit.get(context).posts.length,
                    ),
                    // SizedBox(height: 100,),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

Widget buildPostItem(PostModel model, context, index) {
  var textController = TextEditingController();
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 20,
    margin: EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          model.name,
                          style: TextStyle(
                            height: 1.5,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.check_circle,
                          size: 15,
                          color: Colors.blue,
                        )
                      ],
                    ),
                    Text(
                      model.dateTime,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            height: 1.5,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz_outlined),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            model.text,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 5,
          ),
          if (model.tags != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 7),
              child: Container(
                width: double.infinity,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Container(
                        height: 25,
                        child: MaterialButton(
                          height: 25,
                          minWidth: 1,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Text(
                            '#Software',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: defaultColor,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (model.postImage != null && model.postImage != "")
            Container(
                height: 160,
                width: double.infinity,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageUrl: model.postImage!,
                )),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    SocialCubit.get(context).likePost(
                        SocialCubit.get(context).postsId[index], index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                        ),
                        SizedBox(width: 5),
                        Text('${SocialCubit.get(context).likes[index]}'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    SocialCubit.get(context).toggleComments(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          IconBroken.Message,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 5),
                        Text(
                            '${SocialCubit.get(context).comments[index].length} comment'),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey,
          ),
          SizedBox(
            height: 5,
          ),
          if (SocialCubit.get(context)
                  .isCommentOpen[SocialCubit.get(context).postsId[index]] ==
              true)
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, ind) {
                  return Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  '${SocialCubit.get(context).comments[index][ind].image as String}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[300],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        SocialCubit.get(context)
                                            .comments[index][ind]
                                            .username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: 14,
                                            ),
                                      ),
                                      Text(
                                        SocialCubit.get(context)
                                            .comments[index][ind]
                                            .text,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemCount: SocialCubit.get(context).comments[index].length),
          if (SocialCubit.get(context)
                  .isCommentOpen[SocialCubit.get(context).postsId[index]] ==
              true)
            SizedBox(
              height: 10,
            ),
          // Container(
          //   height: 1,
          //   width: double.infinity,
          //   color:Colors.grey,
          // ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                      '${SocialCubit.get(context).userModel!.image!}',
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          value = textController.text.toString();
                        },
                        controller: textController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Write a comment.....',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   height: 40,
              //   child: InkWell(
              //     onTap: () {
              //       SocialCubit.get(context).likePost(
              //           SocialCubit.get(context).postsId[index], index);
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 5.0),
              //       child: Row(
              //         children: [
              //           Icon(IconBroken.Heart, color: Colors.red),
              //           SizedBox(width: 5),
              //           Text('Like'),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              Container(
                height: 40,
                child: InkWell(
                  onTap: () {
                    if (textController.text != '')
                      SocialCubit.get(context).commentPost(
                          SocialCubit.get(context).postsId[index],
                          index,
                          textController.text);
                    else
                      buildToast(
                          message: 'Your comment can\'t be empty',
                          state: ToastStates.WARNING);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Icon(IconBroken.Send, color: Colors.amber),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

