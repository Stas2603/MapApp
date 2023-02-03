import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:map_app/data/shared_preferances/app_preferances.dart';
import 'package:map_app/src/screens/main_screen/main_screen_cubit.dart';
import 'package:map_app/src/screens/profile_screen/profile_screen_cubit.dart';
import 'package:map_app/src/screens/welcome_screen/welcome_screen_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

init() async {
//Bloc
  sl.registerFactory(
      () => WelcomeScreenCubit(appPreferences: sl(), googleSignInApi: sl()));
  sl.registerFactory(() => MainScreenCubit());
  sl.registerFactory(() => ProfileScreenCubit());

//UseCases

//Repository

//External
  sl.registerLazySingleton(() => GoogleSignIn());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppPreferences(sharedPreferences));

//Core
}
