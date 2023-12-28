import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pichu_oreo/auth/screens/register_screen.dart';
import 'package:pichu_oreo/auth/services/login_service.dart';
import 'package:pichu_oreo/common_widgets/text_field_input.dart';
import 'package:pichu_oreo/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginService loginService = LoginService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void navigateToRegister() {
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void loginUser() {
    setState(() {
      _isLoading = true;
    });

    loginService.login(
      context: context,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFDF6F7),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/logo-main.svg',
                    width: 400,
                    height: 150,
                  ),
                  const Text(
                    'Sign in to your account ❤',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // text field input for email
                  TextFieldInput(
                    hintText: 'Username',
                    textInputType: TextInputType.text,
                    textEditingController: _usernameController,
                  ),
                  const SizedBox(height: 24),
                  // text field input for password
                  TextFieldInput(
                    hintText: 'Password',
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                  ),
                  const SizedBox(height: 24),
                  // button login
                  InkWell(
                    onTap: loginUser,
                    child: Container(
                      width: 380,
                      height: 50,
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          indent: 20.0,
                          endIndent: 10.0,
                          thickness: 1,
                        ),
                      ),
                      Text(
                        "Or continue with",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Expanded(
                        child: Divider(
                          indent: 10.0,
                          endIndent: 20.0,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        color: secondaryColor,
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google.jpg',
                                  width: 25,
                                  height: 25,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Google',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Don't have account?"),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: navigateToRegister,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  // transitioning to signing up
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
