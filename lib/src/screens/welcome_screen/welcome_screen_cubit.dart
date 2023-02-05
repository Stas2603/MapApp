import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:map_app/data/shared_preferances/app_preferances.dart';
import 'package:map_app/src/models/auth_user.dart';
import 'package:map_app/src/models/userInfo.dart' as app;
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

    final userName = _user!.displayName ?? 'User';
    final userEmail = _user!.email;
    final userAvatar = _user!.photoUrl ?? 'assets/images/anonymous_user.png';

    appPreferences.putString('userName', userName);
    appPreferences.putString('userEmail', userEmail);
    appPreferences.putString('userAvatar', userAvatar);

    await _getAllUsersEmail();

    state.userEmailList.forEach((user) async {
      if (user.email.contains(userEmail)) {
        emit(state.copyWith(isRegisterPrevious: true));
        appPreferences.putString('userId', user.id);
      }
    });

    if (state.isRegisterPrevious == false) {
      await addUserToFirebaseDB(userName, userEmail, userAvatar);
    }
  }

  Future<GoogleSignInAccount?> googleLogin() async {
    return await googleSignInApi.signIn();
  }

  Future<void>? addUserToFirebaseDB(
    String userName,
    String userEmail,
    String userAvatar,
  ) async {
    try {
      final user = app.UserInfo(
          name: userName,
          email: userEmail,
          avatarUrl: userAvatar,
          latitude: '0',
          longitude: '0');

      DatabaseReference ref = FirebaseDatabase.instance.ref("users/");
      DatabaseReference newRef = ref.push();
      String? newKey = newRef.key;

      _addNewUser(user, newKey);
    } catch (e) {
      print(e);
    }
  }

  void _addNewUser(app.UserInfo user, String? newKey) {
    try {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref("users/$newKey");
      reference.set(user.toMap());
      appPreferences.putString('userId', newKey!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAllUsersEmail() async {
    final List<AuthUser> emailList = [];

    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(
          snapshot.value as Map,
        );
        data.forEach((key, value) {
          final String userEmail = value['email'];
          emailList.add(AuthUser(
            id: key,
            email: userEmail,
          ));
        });
        emit(state.copyWith(userEmailList: emailList));
      }
    } catch (e) {
      print(e);
    }
  }
}
