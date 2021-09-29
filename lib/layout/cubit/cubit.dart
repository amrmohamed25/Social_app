import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/social_model/chat_model.dart';
import 'package:social_app/models/social_model/comment_model.dart';
import 'package:social_app/models/social_model/post_model.dart';
import 'package:social_app/models/social_model/user_model.dart';
import 'package:social_app/shared/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  SocialUserModel? userModel;
  bool needRefresh = false;

  List titles = ['News Feed', 'Chat', 'New Post', 'Message', 'Settings'];

  List screens = [
    SocialFeed(),
    SocialChat(),
    NewPostScreen(),
    SocialMessage(),
    SocialSetting()
  ];

  int currentIndex = 0;

  void setIndex(int index) {
    if (index == 1) getUsers();
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeNavBarState());
    }
  }

  void getUserData() async {
    emit(SocialGetUserLoadingState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      userModel =
          SocialUserModel.fromJson(value.data() as Map<String, dynamic>);

      nameController.text = userModel!.name;
      bioController.text = userModel!.bio == null ? '' : userModel!.bio!;
      phoneController.text = userModel!.phone;

      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  void refreshAfterValidation() {
    needRefresh = true;
    FirebaseAuth.instance.currentUser!.reload();
    emit(SocialRefreshState());
  }

  File? profileImage;
  final picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  Future uploadProfileImage() async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) async {
      await value.ref.getDownloadURL().then((value) {
        profileUrl = value;
        print(value);
        emit(SocialProfileImagePickedSuccessState());
        firebase_storage.FirebaseStorage.instance
            .refFromURL(userModel!.image as String)
            .delete();
      }).catchError((error) {
        emit(SocialProfileImagePickedErrorState());
      });
    }).catchError((error) {
      emit(SocialProfileImagePickedErrorState());
    });
  }

  Future uploadCoverImage() async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) async {
      await value.ref.getDownloadURL().then((value) {
        coverUrl = value;
        print(value);
        emit(SocialCoverImagePickedSuccessState());
        firebase_storage.FirebaseStorage.instance
            .refFromURL(userModel!.cover as String)
            .delete();
      }).catchError((error) {
        emit(SocialCoverImagePickedErrorState());
      });
    }).catchError((error) {
      emit(SocialCoverImagePickedErrorState());
    });
  }

  String? profileUrl;
  String? coverUrl;

  void updateUser(
      {required String name,
      required String phone,
      required String bio}) async {
    emit(SocialUpdateUserLoadingState());
    int temp = 0;
    if (profileImage != null) {
      await uploadProfileImage();
      temp = 1;
    }
    if (coverImage != null) {
      await uploadCoverImage();
      temp = 1;
    }
    if (phone != userModel!.phone ||
        name != userModel!.name ||
        bio != userModel!.bio) {
      temp = 1;
    }
    if (temp == 1) {
      var newModel = SocialUserModel(
          name: name,
          phone: phone,
          image: profileUrl ?? userModel!.image,
          cover: coverUrl ?? userModel!.cover,
          bio: bio,
          uId: userModel!.uId,
          email: userModel!.email);
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update(newModel.toMap())
          .then((value) {
        getUserData();
      }).catchError((error) {
        emit(SocialUpdateUserErrorState());
      });
    }
  }

  File? postImage;

  void clearPostImage() {
    postImage = null;
    emit(SocialClearPostImageState());
  }

  void getPostImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      emit(SocialPostImagePickedErrorState());
    }
  }

  void createPost(
      {required String text,
      required String dateTime,
      String? tags,
      String? postImage}) {
    emit(SocialCreatePostLoadingState());
    PostModel postModel = PostModel(
        name: userModel!.name,
        uId: userModel!.uId,
        dateTime: dateTime,
        text: text,
        postImage: postImage ?? '',
        image: userModel!.image,
        tags: tags ?? '');

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
      getPosts();
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void getPosts() async {
    posts = [];
    postsId = [];
    likes = [];
    FirebaseFirestore.instance.collection('posts').get().then((value) async {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {
          emit(SocialGetPostsErrorState());
        });
        isCommentOpen.addAll({element.id: false});
        print(element.id);
        List<CommentModel> comment = [];
        element.reference.collection('comments').get().then((val) async {
          for (var e in val.docs) {
            comment.add(CommentModel.fromJson(e.data()));
          }
          // comments.add(CommentModel.fromJson(e.data()));
          // return Future.delayed(Duration(milliseconds: 100));

          comments.add(comment);
          print(comments.length);
        });
      }

      await Future.wait(value.docs.map((element) {
        isCommentOpen.addAll({element.id: false});
        print(element.id);
        List<CommentModel> comment = [];
        return element.reference
            .collection('comments')
            .get()
            .then((value) async {
          await Future.wait(value.docs.map((e) {
            comment.add(CommentModel.fromJson(e.data()));

            // comments.add(CommentModel.fromJson(e.data()));
            return Future.delayed(Duration(milliseconds: 100));
          }));
          comments.add(comment);
          print(comments.length);
        });
      }));
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetPostsErrorState());
    });
  }

  PostModel? postModel;

  void uploadPostImage(
      {required String text, required String dateTime, String? tags}) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
            text: text, dateTime: dateTime, tags: tags, postImage: value);

        emit(SocialPostImagePickedSuccessState());
      }).catchError((error) {
        emit(SocialPostImagePickedErrorState());
        print(error);
      });
    }).catchError((error) {
      emit(SocialPostImagePickedErrorState());
      print(error);
    });
  }

  List posts = [];
  List postsId = [];
  List likes = [];

  void likePost(String postId, int index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .get()
        .then((value) {
      print(value['like']);
      if (value['like'] == false) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(userModel!.uId)
            .set({'like': true}).then((value) {
          likes[index]++;
          emit(SocialLikePostSuccessState());
        });
      } else {
        likes[index]--;
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(userModel!.uId)
            .set({'like': false}).then((value) {
          emit(SocialLikePostSuccessState());
        });
      }
    }).catchError((error) {
      print(error.toString());
      if (error.toString() ==
          'Bad state: cannot get a field on a DocumentSnapshotPlatform which does not exist') {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(userModel!.uId)
            .set({'like': true}).then((value) {
          likes[index]++;
          emit(SocialLikePostSuccessState());
        });
      }
      emit(SocialLikePostErrorState());
    });
  }

  List<List<CommentModel>> comments = [];

  void commentPost(String postId, int index, String text) {
    CommentModel commentModel = CommentModel(
        username: userModel!.name, image: userModel!.image, text: text);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        // .doc(userModel!.uId)//Bossss kda hna
        .doc()
        .set(commentModel.toMap())
        .then((value) {
      comments[index].add(commentModel);
      // isCommentOpen.addAll({postId:false});

      emit(SocialCommentPostSuccessState());
      // comments[index].comments.add(commentModel); take care

      getPosts();
    }).catchError((error) {
      emit(SocialCommentPostErrorState());
    });
  }

  // List<CommentModel> comment=[];//moshkla hna 3shan commentModel wa7d le kol l fl screen f lazm tt3dl
  //lazm 3shan azhr comments yb2a das 3la index da
  //fekra 7lwa: hst3ml comments eny ab3t list so8yyra awl m ydoos 3la button comment
  void toggleComments(int index) {
    print(isCommentOpen);

    isCommentOpen[postsId[index]] = !isCommentOpen[postsId[index]]!;

    emit(SocialToggleCommentState());
  }

  Map<String, bool> isCommentOpen = {};
  List<SocialUserModel> users = [];

  void getUsers() {
    users = [];
    emit(SocialGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) async {
      Future.wait(await value.docs.map((e) {
        if (e.data()['uId'] != userModel!.uId)
          users.add(SocialUserModel.fromJson(e.data()));
        return Future.delayed(Duration(milliseconds: 1));
      }));
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUsersErrorState());
    });
  }

  File? chatMessageImage;
  String? chatMessageImageUrl;

  Future getChatMessageImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      chatMessageImage = File(pickedFile.path);

      emit(SocialChatMessageImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialChatMessageImagePickedErrorState());
    }
  }

  Future uploadChatMessageImage() async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'chatImages/${Uri.file(chatMessageImage!.path).pathSegments.last}')
        .putFile(chatMessageImage!)
        .then((value) async {
      await value.ref.getDownloadURL().then((value) {
        chatMessageImageUrl = value;
        print(value);
        emit(SocialChatMessageImagePickedSuccessState());
      }).catchError((error) {
        emit(SocialChatMessageImagePickedErrorState());
      });
    }).catchError((error) {
      emit(SocialChatMessageImagePickedErrorState());
    });
  }

  void clearChatImage() {
    chatMessageImage = null;
    emit(SocialClearChatMessageImageState());
  }

  void sendMessage(
      {required String receiverUId,
      String? text,
      required String dateTime}) async {
    print('Chattttttttttt${chatMessageImage}tttttttttttttt= $chatMessageImageUrl');
    if (chatMessageImage !=null) {
      await uploadChatMessageImage();
    }
    var chat = ChatModel(userModel!.uId, receiverUId, dateTime, text??"", chatMessageImageUrl ?? "");
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverUId)
        .collection('messages')
        .add(chat.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error);
      emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(chat.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
      clearChatImage();
      chatMessageImageUrl = null;
    }).catchError((error) {
      print(error);
      emit(SocialSendMessageErrorState());
    });
  }

  List<ChatModel> messages = [];

  void getMessages(String receiverUId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverUId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(ChatModel.fromJson(element.data()));
        emit(SocialReceiveMessageSuccessState());
      });
    });
  }
}

// void getPosts() async {
//   posts = [];
//   postsId = [];
//   likes = [];
//   FirebaseFirestore.instance.collection('posts').get().then((value) async {
//     await Future.wait(value.docs.map((element) {
//       return element.reference.collection('likes').get().then((value) {
//         likes.add(value.docs.length);
//         postsId.add(element.id);
//         posts.add(PostModel.fromJson(element.data()));
//       }).catchError((error) {
//         emit(SocialGetPostsErrorState());
//       });
//     }));
//     await FirebaseFirestore.instance
//         .collection('posts')
//         .get()
//         .then((value) async {
//       await Future.wait(value.docs.map((element) {
//         isCommentOpen.addAll({element.id: false});
//         print(element.id);
//         List<CommentModel> comment = [];
//         return element.reference
//             .collection('comments')
//             .get()
//             .then((value) async {
//           await Future.wait(value.docs.map((e) {
//             comment.add(CommentModel.fromJson(e.data()));
//
//             // comments.add(CommentModel.fromJson(e.data()));
//             return Future.delayed(Duration(milliseconds: 100));
//           }));
//           comments.add(comment);
//           print(comments.length);
//         });
//       }));
//     });
//     emit(SocialGetPostsSuccessState());
//   }).catchError((error) {
//     print(error.toString());
//     emit(SocialGetPostsErrorState());
//   });
// }
