import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:innogeeks_app/constants/colors.dart';
import 'package:innogeeks_app/features/auth/bloc/auth_cubit.dart';
import 'package:innogeeks_app/features/auth/ui/sign_in_page.dart';
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

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(
    ProviderScope(
      child: MyApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
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


