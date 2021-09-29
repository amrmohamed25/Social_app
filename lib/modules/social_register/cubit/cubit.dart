import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_model/user_model.dart';
import 'package:social_app/modules/social_register/cubit/social_states.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData icon = Icons.visibility;

  void userRegister(
      {required String email,
      required String password,
      required String name,
      required String phone}) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(email: email, name: name, phone: phone, uId: value.user!.uid);
      // uId=value.user!.uid;
      // emit(SocialRegisterSuccessState());
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate(
      {required String email,
      required String name,
      required String phone,
      required String uId}) {
    SocialUserModel model = SocialUserModel(
        name: name,
        phone: phone,
        email: email,
        uId: uId,
        image:
            'https://image.freepik.com/free-photo/pretty-european-woman-casual-sweater-pink-wall_343596-5881.jpg',
        cover:
            'https://image.freepik.com/free-photo/pretty-european-woman-pink-blouse-yellow-wall_343596-5973.jpg',
        bio: 'Please enter your bio....');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialUserCreateSuccessState(uId));
    }).catchError((error) {
      emit(SocialUserCreateErrorState(error.toString()));
    });
  }

  void changeVisibility() {
    isPassword = !isPassword;
    icon = isPassword == true ? Icons.visibility : Icons.visibility_off;
    emit(SocialChangeRegisterVisibility());
  }
}
