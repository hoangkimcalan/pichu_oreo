import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pichu_oreo/auth/screens/login_screen.dart';
import 'package:pichu_oreo/common_widgets/custom_clippath.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  void navigateToLogin() {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        centerTitle: false,
        leading: const SizedBox(),
        backgroundColor: const Color(0xFFFDF6F7),
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "The best photos",
                style: TextStyle(
                  color: Color(0xFF7c6672),
                  fontSize: 34,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "from good people",
                style: TextStyle(
                  color: Color(0xFF7c6672),
                  fontSize: 34,
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0XFFf2ccd3),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      height: 300,
                      color: const Color(0xFFFDF6F7),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/image 3.jpg',
              height: 400,
              fit: BoxFit.contain, // Adjust the fit based on your needs
            ),
            GestureDetector(
              onTap: navigateToLogin,
              child: Container(
                width: 280,
                height: 55,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xff9796f0),
                      Color.fromARGB(255, 251, 159, 182),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      child: Icon(
                        Icons.arrow_forward_outlined,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
