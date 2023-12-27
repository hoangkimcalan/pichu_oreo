import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pichu_oreo/utils/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class UserService {
  Future<String> getUserId({
    required BuildContext context,
    required String username,
  }) async {
    Map<String, dynamic> requestData = {
      "username": username,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authorization');

    http.Response res = await http.post(
      Uri.parse('$uri/api/auth/getDataFrUsername'),
      body: jsonEncode(requestData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token!}'
      },
    );

    Map<String, dynamic> jsonResponse = jsonDecode(res.body);
    log('data res $jsonResponse');
    Map<String, dynamic> ecodeValue = jsonResponse['data'];

    return ecodeValue['id'];
  }
}
