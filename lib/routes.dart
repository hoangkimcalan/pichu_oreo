import 'package:flutter/material.dart';
import 'package:pichu_oreo/auth/screens/login_screen.dart';
import 'package:pichu_oreo/auth/screens/register_screen.dart';
import 'package:pichu_oreo/home/screens/edit_profile_screen.dart';
import 'package:pichu_oreo/responsive/mobile_screen_layout.dart';
import 'package:pichu_oreo/responsive/responsive_layout_screen.dart';
import 'package:pichu_oreo/responsive/web_screen_layout.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );

    case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterScreen(),
      );

    case ResponsiveLayout.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobilecreenLayout(),
        ),
      );

    case EditProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const EditProfileScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Page route doesnt exist!'),
          ),
        ),
      );
  }
}
