import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/shared_preferences.dart';
import 'package:social_app/shared/network/remote/dio_remote.dart';

import 'bloc_observer.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.notification!.title}");
  buildToast(message: message.notification!.body, state: ToastStates.SUCCESS);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  await Firebase.initializeApp();

  await CacheHelper.init();
  //
  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.sentTime}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      print(message.data.toString());
      buildToast(message: message.notification!.body, state: ToastStates.SUCCESS);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    print(message.data.toString());
    buildToast(message: message.notification!.body, state: ToastStates.SUCCESS);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Widget myWidget;
  token = CacheHelper.getData('token');
  uId = CacheHelper.getData('uId');
  if (uId != null) {
    myWidget = SocialLayout();
  } else {
    myWidget = SocialLoginScreen();
  }

  runApp(MyApp(myWidget));
}

class MyApp extends StatelessWidget {
  Widget myWidget;

  MyApp( this.myWidget);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SocialCubit()
          ..getUserData()
          ..getPosts();
      },
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: myWidget
              );
        },
      ),
    );
  }
}
