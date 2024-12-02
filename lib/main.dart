import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:innogeeks_app/constants/colors.dart';
import 'package:innogeeks_app/features/auth/bloc/auth_cubit.dart';
import 'package:innogeeks_app/features/auth/ui/splash_screen.dart';
import 'package:innogeeks_app/features/nav_bar/ui/nav_bar.dart';
import 'package:innogeeks_app/routes/routes_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/nav_bar/bloc/nav_bar_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'innogeeks',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  await _initLocalNotifications();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      print(message.data['body']);
    }
    _showLocalNotification(message);

    if (message.notification != null) {
      if (kDebugMode) {
        print('Message also contained a notification: ${message.notification}');
      }
    }
  });

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(
    ProviderScope(
      child: MyApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
}

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/launch_background');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

Future<void> backgroundMessageHandler(RemoteMessage message) async{
  if (kDebugMode) {
    print('onBackground: ${message.notification?.title}/ ${message.notification?.body}/ ${message.notification?.titleLocKey}');
  }
  await Firebase.initializeApp();
}

  void _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'innogeeks',
      'innogeeks',
      channelDescription: '',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/launch_background',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(
        android: androidPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.data['title'],
      message.data['body'],
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  final userIdMain = FirebaseAuth.instance.currentUser!.uid;

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  final RouteGenerator routeGenerator = RouteGenerator();

  MyApp({super.key, required this.hasSeenOnboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = AuthCubit();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>AuthCubit()),
        BlocProvider(create: (context) => NavBarBloc()),
      ],
      child: MaterialApp(
        title: 'Only Geeks',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryInnoColor),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          bloc: authCubit,
          buildWhen: (previous,current){
            return previous is AuthInitialState;
          },
          builder: (context,state){
            if(state is AuthLoggedInState){
              return MaterialApp(
                initialRoute: '/',
                onGenerateRoute: routeGenerator.generateRoute,
              );
            }else if(state is AuthLoggedOutState){
              return const SplashScreen(); //Splash screen to be returned
            }else{
              return const NavBar(); // HomeScreen
            }
          },
        ),
      ),
    );
  }
}


