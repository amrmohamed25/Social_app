import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/shared_preferences.dart';

import 'cubit/cubit.dart';
import 'cubit/social_states.dart';

class SocialRegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return SocialRegisterCubit();
        },
        child: BlocConsumer<SocialRegisterCubit,SocialRegisterStates>(
            builder: (context, state) {
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
                              'Register',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 30),
                            ),
                            Text(
                              'Register to communicate with your friends',
                            ),
                            defaultFormField(
                                controller: nameController,
                                label: 'Name',
                                keyType: TextInputType.text,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return 'Name is too short';
                                  }
                                  return null;
                                },
                                prefix: Icons.person,),
                            SizedBox(
                              height: 10,
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
                                  SocialRegisterCubit.get(context).changeVisibility();
                                },
                                isPassword: SocialRegisterCubit.get(context).isPassword,
                                prefix: Icons.lock,
                                suffix: SocialRegisterCubit.get(context).icon),
                            SizedBox(
                              height: 10,
                            ),
                            defaultFormField(
                                controller: phoneController,
                                label: 'Phone',
                                keyType: TextInputType.phone,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return 'Phone is too short';
                                  }
                                  return null;
                                },
                                prefix: Icons.phone,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            state is! SocialRegisterLoadingState?
                            defaultButton(
                              text: 'Register',
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  SocialRegisterCubit.get(context).userRegister(email: emailController.text, password: passwordController.text, name: nameController.text, phone: phoneController.text);
                                }
                              },
                            ):Center(child:CircularProgressIndicator()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            listener: (context, state) {
              if(state is SocialRegisterErrorState){
                buildToast(message: state.error, state: ToastStates.ERROR);
              }
              if(state is SocialUserCreateSuccessState){
                CacheHelper.setData(key: 'uId', value: state.uId);
                uId=state.uId;
                print('Here is your uid kido : $uId');
                navigateAndReplace(context, SocialLayout());
              }
            }));
  }
}
