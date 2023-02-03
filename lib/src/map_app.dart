import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/service_locator.dart';
import 'package:map_app/src/navigation/route_generator.dart';
import 'package:map_app/src/screens/main_screen/main_screen_cubit.dart';
import 'package:map_app/src/screens/main_screen/main_screen_view.dart';
import 'package:map_app/src/screens/profile_screen/profile_screen_cubit.dart';
import 'package:map_app/src/screens/welcome_screen/welcome_screen_cubit.dart';
import 'package:map_app/src/screens/welcome_screen/welcome_screen_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MapApp extends StatelessWidget {
  const MapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WelcomeScreenCubit>(
            create: (context) => sl<WelcomeScreenCubit>()),
        BlocProvider<MainScreenCubit>(
            create: (context) => sl<MainScreenCubit>()),
        BlocProvider<ProfileScreenCubit>(
            create: (context) => sl<ProfileScreenCubit>()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return const MainScreenView();
            } else {
              return const WelcomeScreenView();
            }
          }),
        ),
      ),
    );
  }
}
