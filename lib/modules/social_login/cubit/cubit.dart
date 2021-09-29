import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/social_login/cubit/social_states.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates>{
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context)=> BlocProvider.of(context);

  bool isPassword=true;

  void userLogin({required String email,required String password}){
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
      // uId=value.user!.uid;
      emit(SocialLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(SocialLoginErrorState(error.toString()));
    });
  }
  IconData icon=Icons.visibility;
  void changeVisibility(){
    isPassword=!isPassword;
    icon=isPassword==true?Icons.visibility:Icons.visibility_off;
    emit(SocialChangeLoginVisibility());
  }
}


