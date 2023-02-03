import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:map_app/data/shared_preferances/app_preferances.dart';
import 'package:map_app/src/app_settings/app_settings.dart';
import 'package:map_app/src/screens/welcome_screen/welcome_screen_state.dart';

class WelcomeScreenCubit extends Cubit<WelcomeScreenState> {
  WelcomeScreenCubit({
    required this.appPreferences,
    required this.googleSignInApi,
  }) : super(const WelcomeScreenState());

  final AppPreferences appPreferences;
  final GoogleSignIn googleSignInApi;

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future onGoogleSignIn() async {
    final googleUser = await googleLogin();

    if (googleUser == null) return;

    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    appPreferences.putString('user', _user!.email);
  }

  Future<GoogleSignInAccount?> googleLogin() async {
    return await googleSignInApi.signIn();
  }
}
