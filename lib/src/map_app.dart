import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/service_locator.dart';
import 'package:map_app/src/navigation/route_generator.dart';
import 'package:map_app/src/screens/main_screen/main_screen_cubit.dart';
import 'package:map_app/src/screens/profile_screen/profile_screen_cubit.dart';
import 'package:map_app/src/screens/welcome_screen/welcome_screen_cubit.dart';
import 'package:map_app/src/screens/welcome_screen/welcome_screen_view.dart';

class MapApp extends StatelessWidget {
  const MapApp({super.key});

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
        onGenerateRoute: RouteGenerator.generateRoute,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const WelcomeScreenView(),
      ),
    );
  }
}
