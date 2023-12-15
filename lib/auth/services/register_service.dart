// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pichu_oreo/auth/screens/login_screen.dart';
import 'package:pichu_oreo/common_widgets/error_handling.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:pichu_oreo/utils/global_variables.dart';

import 'package:http/http.dart' as http;

class RegisterService {
  void register({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      log('server log: $uri');

      Map<String, dynamic> requestData = {
        "username": username,
        "email": email,
        "password": password,
        "roles": ["user"],
      };

      log('data request register: $requestData');

      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/signup'),
        body: jsonEncode(requestData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
