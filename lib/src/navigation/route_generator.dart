import 'package:flutter/material.dart';
import 'package:map_app/src/screens/main_screen/main_screen_view.dart';
import 'package:map_app/src/screens/profile_screen/profile_screen_view.dart';
import 'package:map_app/src/screens/welcome_screen/welcome_screen_view.dart';

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreenView(),
        );
      case '/main':
        return MaterialPageRoute(
          builder: (context) => const MainScreenView(),
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (context) => const ProfileScreenView(),
        );
    }
    return routeExeption();
  }
}

Route routeExeption() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(child: Text('Error')),
    );
  });
}
