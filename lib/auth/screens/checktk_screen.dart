import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pichu_oreo/auth/services/login_service.dart';
import 'package:pichu_oreo/common_widgets/text_field_input.dart';

class CheckTkScreen extends StatefulWidget {
  static const String routeName = '/checkTk-screen';

  const CheckTkScreen({super.key});

  @override
  State<CheckTkScreen> createState() => _CheckTkScreenState();
}

class _CheckTkScreenState extends State<CheckTkScreen> {
  final TextEditingController _tokenController = TextEditingController();
  bool _isLoading = false;
  final LoginService loginService = LoginService();

  @override
  void dispose() {
    super.dispose();
    _tokenController.dispose();
  }

  void sendTokenReset() {
    setState(() {
      _isLoading = true;
    });

    loginService.sendToken(
      context: context,
      email: _tokenController.text,
    );

    setState(() {
      _isLoading = false;
      _tokenController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFDF6F7),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDF6F7),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
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
                    'Securely regain account access 😎',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFieldInput(
                    hintText: 'Enter your token',
                    textInputType: TextInputType.text,
                    textEditingController: _tokenController,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: sendTokenReset,
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
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
