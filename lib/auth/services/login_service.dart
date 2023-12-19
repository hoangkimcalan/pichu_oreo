// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pichu_oreo/common_widgets/error_handling.dart';
import 'package:pichu_oreo/utils/utils.dart';
import 'package:pichu_oreo/providers/user_provider.dart';
import 'package:pichu_oreo/responsive/responsive_layout_screen.dart';
import 'package:pichu_oreo/utils/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  void login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    Map<String, dynamic> requestData = {
      "username": username,
      "password": password,
    };

    http.Response res = await http.post(
      Uri.parse('$uri/api/auth/login'),
      body: jsonEncode(requestData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> jsonResponse = jsonDecode(res.body);
    log('data res $jsonResponse');
    Map<String, dynamic> ecodeValue = jsonResponse['data'];

    Map<String, dynamic> userData = {
      "id": ecodeValue['id'],
      "username": ecodeValue['username'],
      "email": ecodeValue['email'],
      "roles": ecodeValue['roles'],
    };

    String userDataJson = json.encode(userData);
    log("res: $userDataJson");

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        Provider.of<UserProvider>(context, listen: false).setUser(userDataJson);

        await prefs.setString('authorization', ecodeValue['token']);
        Navigator.of(context).pushNamedAndRemoveUntil(
          ResponsiveLayout.routeName,
          (route) => false,
        );
      },
    );
  }

  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authorization');

      if (token == null) {
        prefs.setString('authorization', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/api/auth/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token!}'
        },
      );

      Map<String, dynamic> jsonResponse = jsonDecode(tokenRes.body);

      log("token request ${jsonResponse['ecode']}");
      String response = jsonResponse['ecode'];

      // var response = jsonDecode(tokenRes.body);

      if (response == '000') {
        http.Response userRes = await http.get(
          Uri.parse('$uri/api/auth/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
        );

        Map<String, dynamic> jsonResponse = jsonDecode(userRes.body);
        Map<String, dynamic> ecodeValue = jsonResponse['data'];

        Map<String, dynamic> userData = {
          "id": ecodeValue['id'],
          "username": ecodeValue['username'],
          "email": ecodeValue['email'],
          "roles": ecodeValue['roles'],
          "avatar":
              "https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png"
        };

        String userDataJson = json.encode(userData);

        var userProvider = Provider.of<UserProvider>(context, listen: false);

        userProvider.setUser(userDataJson);

        log('dataaa $jsonResponse');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
