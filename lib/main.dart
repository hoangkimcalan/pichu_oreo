import 'package:flutter/material.dart';
import 'package:pichu_oreo/admin/screens/admin_screen.dart';
import 'package:pichu_oreo/auth/screens/login_screen.dart';
import 'package:pichu_oreo/auth/services/login_service.dart';
import 'package:pichu_oreo/home/screens/intro_screen.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:pichu_oreo/responsive/mobile_screen_layout.dart';
import 'package:pichu_oreo/responsive/responsive_layout_screen.dart';
import 'package:pichu_oreo/responsive/web_screen_layout.dart';
import 'package:pichu_oreo/routes.dart';
import 'package:pichu_oreo/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LoginService loginService = LoginService();

  @override
  void initState() {
    // TODO: implement initState
    loginService.getUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Social Network',
      theme: ThemeData(
        tooltipTheme: const TooltipThemeData(preferBelow: false),
        scaffoldBackgroundColor: mobileBackgroundColor,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.roles.isNotEmpty
          ? Provider.of<UserProvider>(context).user.roles.contains('ROLE_USER')
              ? const IntroScreen()
              : const AdminScreen()
          : const LoginScreen(),
    );
  }
}
