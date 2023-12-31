// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pichu_oreo/auth/screens/checktk_screen.dart';
import 'package:pichu_oreo/auth/screens/login_screen.dart';
import 'package:pichu_oreo/auth/screens/newpw_screen.dart';
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
    Map<String, dynamic> ecodeValue = jsonResponse['data'];

    Map<String, dynamic> userData = {
      "id": ecodeValue['id'],
      "username": ecodeValue['username'],
      "email": ecodeValue['email'],
      "roles": ecodeValue['roles'],
      "avatar": ecodeValue['avatar']
    };

    String userDataJson = json.encode(userData);

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

  void sendToken({
    required BuildContext context,
    required String email,
  }) async {
    Map<String, dynamic> requestData = {
      "email": email,
    };

    http.Response res = await http.post(
      Uri.parse('$uri/api/auth/resetPw'),
      body: jsonEncode(requestData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> jsonResponse = jsonDecode(res.body);

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () async {
        if (jsonResponse['ecode'] == "000") {
          showSnackBar(context, "Sent token to your email. Please got it ✔");
          Navigator.of(context).pushNamedAndRemoveUntil(
            CheckTkScreen.routeName,
            (route) => false,
          );
        } else {
          showSnackBar(context, "Oops! Not found your email 😢");
        }
      },
    );
  }

  void checkToken({
    required BuildContext context,
    required String token,
  }) async {
    Map<String, dynamic> requestData = {
      "token": token,
    };

    http.Response res = await http.put(
      Uri.parse('$uri/api/auth/resetPw'),
      body: jsonEncode(requestData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> jsonResponse = jsonDecode(res.body);

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () async {
        if (jsonResponse['ecode'] == "000") {
          showSnackBar(context, "Done ✔, Please set new password");
          Navigator.of(context).pushNamedAndRemoveUntil(
            NewPwScreen.routeName,
            (route) => false,
            arguments: jsonResponse['data'],
          );
        } else {
          showSnackBar(context, "Oops! Not match your token 😢");
        }
      },
    );
  }

  void setNewPw({
    required BuildContext context,
    required String newPassword,
    required String email,
  }) async {
    Map<String, dynamic> requestData = {
      "newPassword": newPassword,
      "email": email,
    };

    http.Response res = await http.post(
      Uri.parse('$uri/api/auth/setNewPw'),
      body: jsonEncode(requestData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> jsonResponse = jsonDecode(res.body);

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () async {
        if (jsonResponse['ecode'] == "000") {
          showSnackBar(context, "Done ✔");
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        } else {
          showSnackBar(context, "Oops! Some wrongs 😢");
        }
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

      String response = jsonResponse['ecode'];

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
          "avatar": ecodeValue['avatar'],
          "firstName": ecodeValue['firstName'],
          "lastName": ecodeValue['lastName'],
          "workplace": ecodeValue['workplace'],
          "address": ecodeValue['address'],
          "phone": ecodeValue['phone']
        };

        String userDataJson = json.encode(userData);

        var userProvider = Provider.of<UserProvider>(context, listen: false);

        userProvider.setUser(userDataJson);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
