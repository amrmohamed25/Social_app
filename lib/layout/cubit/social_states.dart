abstract class SocialStates{}

class SocialInitialState extends SocialStates{}

class SocialGetUserLoadingState extends SocialStates{}

class SocialGetUserSuccessState extends SocialStates{}

class SocialGetUserErrorState extends SocialStates{
  String error;
  SocialGetUserErrorState(this.error);
}

class SocialRefreshState extends SocialStates{}

class SocialChangeNavBarState extends SocialStates{}

class SocialNewPostState extends SocialStates{}

class SocialProfileImagePickedSuccessState extends SocialStates{}

class SocialProfileImagePickedErrorState extends SocialStates{}

class SocialCoverImagePickedSuccessState extends SocialStates{}

class SocialCoverImagePickedErrorState extends SocialStates{}

class SocialUpdateUserLoadingState extends SocialStates{}

class SocialUpdateUserErrorState extends SocialStates{}

class SocialCreatePostLoadingState extends SocialStates{}

class SocialPostImagePickedSuccessState extends SocialStates{}

class SocialPostImagePickedErrorState extends SocialStates{}

class SocialCreatePostSuccessState extends SocialStates{}

class SocialCreatePostErrorState extends SocialStates{}

class SocialClearPostImageState extends SocialStates{}

class SocialGetPostsLoadingState extends SocialStates{}

class SocialGetPostsSuccessState extends SocialStates{}

class SocialGetPostSuccessState extends SocialStates{}

class SocialGetPostsErrorState extends SocialStates{}

class SocialLikePostSuccessState extends SocialStates{}

class SocialLikePostErrorState extends SocialStates{}

class SocialCommentPostSuccessState extends SocialStates{}

class SocialCommentPostErrorState extends SocialStates{}

class SocialGetCommentSuccessState extends SocialStates{}

class SocialGetCommentErrorState extends SocialStates{}

class SocialToggleCommentState extends SocialStates{}

class SocialWriteCommentState extends SocialStates{}

class SocialGetAllUsersLoadingState extends SocialStates{}

class SocialGetAllUsersSuccessState extends SocialStates{}

class SocialGetAllUsersErrorState extends SocialStates{}

class SocialSendMessageSuccessState extends SocialStates{}

class SocialSendMessageErrorState extends SocialStates{}

class SocialReceiveMessageSuccessState extends SocialStates{}

class SocialReceiveMessageErrorState extends SocialStates{}

class SocialChatMessageImagePickedSuccessState extends SocialStates{}

class SocialChatMessageImagePickedErrorState extends SocialStates{}

class SocialClearChatMessageImageState extends SocialStates{}