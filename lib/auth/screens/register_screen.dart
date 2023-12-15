import 'package:flutter/material.dart';
import 'package:pichu_oreo/auth/screens/login_screen.dart';
import 'package:pichu_oreo/auth/services/register_service.dart';
import 'package:pichu_oreo/common_widgets/text_field_input.dart';
import 'package:pichu_oreo/utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register-screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterService registerService = RegisterService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void navigateToLogin() {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  void registerUser() {
    setState(() {
      _isLoading = true;
    });

    registerService.register(
      context: context,
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color(0xffECE9E6),
            Color(0xffFFFFFF),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            width: double.infinity,
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(flex: 2, child: Container()),
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: 400,
                    height: 200,
                  ),
                  const Text(
                    'Trading Together, Soaring Forever',
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
                  TextFieldInput(
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
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
                    onTap: registerUser,
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
                        color: blueColor,
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: secondaryColor,
                              ),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                color: mobileBackgroundColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(flex: 2, child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Already have an account?"),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Log in.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
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
