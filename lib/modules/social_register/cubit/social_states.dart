abstract class SocialRegisterStates{}

class SocialRegisterInitialState extends SocialRegisterStates{}

class SocialRegisterLoadingState extends SocialRegisterStates{}

class SocialRegisterSuccessState extends SocialRegisterStates{}

class SocialRegisterErrorState extends SocialRegisterStates{
  String error;

  SocialRegisterErrorState(this.error);
}

class SocialUserCreateSuccessState extends SocialRegisterStates{
  String uId;

  SocialUserCreateSuccessState(this.uId);
}

class SocialUserCreateErrorState extends SocialRegisterStates{
  String error;

  SocialUserCreateErrorState(this.error);
}

class SocialChangeRegisterVisibility extends SocialRegisterStates{}

