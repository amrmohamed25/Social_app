




import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  await Firebase.initializeApp();
  //
  // if (Platform.isLinux) await DesktopWindow.setMinWindowSize(Size(400, 650));
  //
  await CacheHelper.init();
  //
  // var token = await FirebaseMessaging.instance.getToken();
  // print(token);
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.sentTime}');
  //
  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //     print(message.data.toString());
  //     buildToast(message: message.notification!.body, state: ToastStates.SUCCESS);
  //   }
  // });
  //
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('A new onMessageOpenedApp event was published!');
  //   print(message.data.toString());
  //   buildToast(message: message.notification!.body, state: ToastStates.SUCCESS);
  // });
  //
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Widget myWidget;
  bool? isDark = CacheHelper.getData('isDark') ?? false;
  bool? finishedBoarding = CacheHelper.getData('boarding') ?? false;
  token = CacheHelper.getData('token');
  uId = CacheHelper.getData('uId');
  if (uId != null) {
    // FirebaseAuth.instance.currentUser!.reload();
    myWidget = SocialLayout();
  } else {
    myWidget = SocialLoginScreen();
  }
  // myWidget=SocialFeed();
  // if(finishedBoarding==true){
  //   if(token!=null){
  //     myWidget=ShopLayout();
  //   }
  //   else{
  //     myWidget=LoginShopScreen();
  //   }
  // }else{
  //   myWidget=OnBoardingScreen();
  // }
  runApp(MyApp(isDark, myWidget));
}

class MyApp extends StatelessWidget {
  bool? isDark;

  // bool? finishedBoarding;
  Widget myWidget;

  MyApp(this.isDark, this.myWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return AppCubit()
            // ..createDatabase()
                ;
          },
        ),
        BlocProvider(
          create: (BuildContext context) {
            return NewsCubit()
              ..getBusiness()
              ..changeThemeMode(isDark);
            // ..getBusiness();
          },
        ),
        BlocProvider(
          create: (BuildContext context) {
            return ShopCubit()
              ..getHomeData()
              ..getCategoryData()
              ..getFavorites()
              ..getUserData();
          },
        ),
        BlocProvider(
          create: (BuildContext context) {
            return SocialCubit()
              ..getUserData()
              ..getPosts();
          },
        )
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          var cubit = AppCubit.get(context);
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: cubit.isDark == true ? ThemeMode.dark : ThemeMode.light,
              home:myWidget
            // NewsLayout(),
            // home:SocialLoginScreen(),
            // home:myWidget,
            // home: finishedBoarding==true?LoginShopScreen():OnBoardingScreen(),
            // NewsLayout(),
          );
        },
      ),
    );
  }
}
