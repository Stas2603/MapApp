import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:map_app/data/shared_preferances/app_preferances.dart';
import 'package:map_app/src/models/selectedUserInfo.dart';
import 'package:map_app/src/screens/main_screen/main_screen_state.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit({
    required this.appPreferences,
    required this.googleSignInApi,
  }) : super(const MainScreenState());

  final AppPreferences appPreferences;
  final GoogleSignIn googleSignInApi;

  void initParams() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
  }

  void onChangeLocation(String latitude, String longitude) async {
    final userId = appPreferences.getString('userId');
    try {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref("users/$userId");
      reference.update({"latitude": latitude});
      reference.update({"longitude": longitude});
    } catch (e) {
      print(e);
    }
  }

  Future<SelectedUserInfo> onTakeSelectedUserInfo(String id) async {
    var selectedUserInfo =
        const SelectedUserInfo(name: '', email: '', avatarUrl: '');
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/$id').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        selectedUserInfo = SelectedUserInfo(
          name: data['name'],
          email: data['email'],
          avatarUrl: data['avatarUrl'],
        );
      } else {
        print('No data available.');
      }
    } catch (e) {
      print(e);
    }
    return selectedUserInfo;
  }

  Future<void> onSignOut() async {
    try {
      await googleSignInApi.signOut();
      await FirebaseAuth.instance.signOut();

      appPreferences.putString('userId', '');
    } catch (e) {
      print(e);
    }
  }
}
