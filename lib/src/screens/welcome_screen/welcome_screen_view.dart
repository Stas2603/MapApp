import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/src/app_resources/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:map_app/src/screens/welcome_screen/welcome_screen_cubit.dart';
import '../../map_app.dart';

class WelcomeScreenView extends StatefulWidget {
  const WelcomeScreenView({super.key});

  @override
  State<WelcomeScreenView> createState() => _WelcomeScreenViewState();
}

class _WelcomeScreenViewState extends State<WelcomeScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTitle(),
              _buildLogo(),
              _buildSignInGoogleButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      LocaleKeys.mapApp.tr(),
      style: const TextStyle(
        fontSize: 40,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/map.png',
      width: 200,
      height: 300,
    );
  }

  Widget _buildSignInGoogleButton(BuildContext context) {
    return InkWell(
      child: Image.asset('assets/images/google_logo.png'),
      onTap: () async {
        await context.read<WelcomeScreenCubit>().onGoogleSignIn();
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      },
    );
  }
}
