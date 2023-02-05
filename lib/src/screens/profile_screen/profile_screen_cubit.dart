import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/data/shared_preferances/app_preferances.dart';
import 'package:map_app/src/screens/profile_screen/profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit({
    required this.appPreferences,
  }) : super(const ProfileScreenState());

  AppPreferences appPreferences;

  void initParams() {
    final userName = appPreferences.getString('userName');
    final userEmail = appPreferences.getString('userEmail');
    final userAvatar = appPreferences.getString('userAvatar');

    emit(
      state.copyWith(
        userAvatar: userAvatar,
        userEmail: userEmail,
        userName: userName,
      ),
    );
  }
}
