import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/social_register/social_register.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/shared_preferences.dart';

import 'cubit/cubit.dart';
import 'cubit/social_states.dart';

class SocialLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return SocialLoginCubit();
        },
        child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
            builder: (context, state) {
              print(SocialLoginCubit.get(context).isPassword);
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 30),
                            ),
                            Text(
                              'Login to communicate with your friends',
                            ),
                            defaultFormField(
                                controller: emailController,
                                label: 'Email',
                                keyType: TextInputType.text,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return 'Email is too short';
                                  }
                                  return null;
                                },
                                prefix: Icons.email),
                            SizedBox(
                              height: 10,
                            ),
                            defaultFormField(
                                controller: passwordController,
                                label: 'Password',
                                keyType: TextInputType.visiblePassword,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return 'Password is too short';
                                  }
                                  return null;
                                },
                                function: () {
                                  SocialLoginCubit.get(context).changeVisibility();
                                },
                                isPassword: SocialLoginCubit.get(context).isPassword,
                                prefix: Icons.lock,
                                suffix: SocialLoginCubit.get(context).icon),
                            SizedBox(
                              height: 10,
                            ),
                            state is! SocialLoginLoadingState?
                            defaultButton(
                              text: 'LOGIN',
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  SocialLoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text);
                                }
                              },
                            ):Center(child:CircularProgressIndicator()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Don\'t have an account?'),
                                TextButton(
                                    onPressed: () {
                                      navigateTo(context, SocialRegisterScreen());
                                    },
                                    child: Text('Register Now'))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            listener: (context, state) {
              if(state is SocialLoginErrorState){
                buildToast(message: state.error, state: ToastStates.ERROR);
              }
              if(state is SocialLoginSuccessState){
                CacheHelper.setData(key: 'uId', value: state.uId);
                uId=state.uId;
                SocialCubit.get(context).getUserData();
                SocialCubit.get(context).getPosts();
                navigateAndReplace(context, SocialLayout());
              }
            }));
  }
}
