abstract class SocialLoginStates {}

class SocialLoginInitialState extends SocialLoginStates {}

class SocialLoginLoadingState extends SocialLoginStates {}

class SocialLoginSuccessState extends SocialLoginStates {
  String uId;

  SocialLoginSuccessState(this.uId);
}

class SocialLoginErrorState extends SocialLoginStates {
  String error;

  SocialLoginErrorState(this.error);
}

class SocialChangeLoginVisibility extends SocialLoginStates {}
